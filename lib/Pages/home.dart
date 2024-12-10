import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grademaster/Pages/assesment/description.dart';

class HomePelajar extends StatelessWidget {
  static const nameRoute = '/homepelajar';

  const HomePelajar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
                  image: DecorationImage(
                    image: AssetImage('assets/ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Beranda',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            DiscountBanner(),
            GenerateCard(),
          ],
        ),
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "Selamat Mengerjakan Tugas!\n"),
            TextSpan(
              text: "Kebenaran Relatif terhadap Penerimanya",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenerateCard extends StatefulWidget {
  const GenerateCard({super.key});

  @override
  GenerateCardState createState() => GenerateCardState();
}

class GenerateCardState extends State<GenerateCard> {
  List<dynamic> _get = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1/note_app/sesi/list.php"),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          // Validate each element in data
          final validData = (jsonResponse['data'] as List)
              .where((element) => element is Map<String, dynamic>)
              .toList();

          setState(() {
            _get = validData;
            _isLoading = false;
          });
        } else {
          print(
              "API Error: ${jsonResponse['message'] ?? 'Unexpected data format'}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_get.isEmpty) {
      return const Center(child: Text("No data available."));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _get.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return AssesmentCard(data: _get[index]);
        },
      ),
    );
  }
}

class AssesmentCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const AssesmentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          elevation: MaterialStateProperty.all(2),
        ),
        onPressed: () {
          final arguments = {
            'id': data['id_assesmen'],
            'nama_sesi': data['nama_assesmen'],
            'keterangan': data['ket_assesmen'],
            'tanggal': data['tanggal'],
            'grade_pass': data['grade_pass'],
          };

          showModalBottomSheet<void>(
            showDragHandle: true,
            context: context,
            isScrollControlled: true,
            constraints: const BoxConstraints(maxWidth: 640),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext context) =>
                DescriptionPage(arguments: arguments),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.00),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: screenSize.width * 0.2,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.17,
                                height:
                                    MediaQuery.of(context).size.width * 0.12,
                                child: Text(
                                  data['nama_assesmen'] ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: screenSize.width * 0.035,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 4,
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.26,
                            child: Text(
                              data['nama_kelas'] ?? '-',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.03,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      )),
                  Container(
                    width: screenSize.width * 0.1,
                    height: screenSize.width * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.import_contacts,
                      color: Colors.white,
                      size: screenSize.width * 0.04,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: screenSize.width * 0.03,
                      ),
                      SizedBox(width: screenSize.width * 0.02),
                      Text(data['tanggal'] ?? '-',
                          style: TextStyle(fontSize: screenSize.width * 0.03)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Passing Grade: ',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.03),
                      ),
                      SizedBox(width: screenSize.width * 0.02),
                      Text(data['grade_pass'] ?? '-',
                          style: TextStyle(fontSize: screenSize.width * 0.03)),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
