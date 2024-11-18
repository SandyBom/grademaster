import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grademaster/Pages/assesment/description.dart';
import 'package:http/http.dart' as http;

class HomePelajar extends StatelessWidget {
  static const nameRoute = '/homepelajar';

  const HomePelajar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 90),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: const [
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
            TextSpan(text: "A Summer Surprise\n"),
            TextSpan(
              text: "Cashback 20%",
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

      print("Raw response: ${response.body}");

      if (response.statusCode == 200) {
        try {
          // Decode JSON sebagai Map
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          // Cek tipe data dari jsonResponse
          print("jsonResponse type: ${jsonResponse.runtimeType}");

          if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
            // Log tipe data untuk memverifikasi
            print("Data is List: ${jsonResponse['data'].runtimeType}");

            // Validasi setiap elemen dalam data
            final validData = (jsonResponse['data'] as List).where((element) {
              if (element is Map<String, dynamic>) {
                return true;
              } else {
                print("Invalid element found: $element");
                return false;
              }
            }).toList();

            setState(() {
              _get = validData;
              _isLoading = false;
            });
          } else {
            print(
                "API Error: ${jsonResponse['message'] ?? 'Unexpected data format'}");
          }
        } catch (jsonError) {
          print("JSON Parsing Error: $jsonError");
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

    print("Data available: $_get"); // Log untuk memastikan data diterima

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
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 144, 241, 147)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/description', // Ganti '/description' dengan nama route yang sesuai
            arguments: {
              'id': data['id'], // Kirim ID
              'keterangan': data['keterangan_sesi'], // Kirim keterangan_sesi
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenSize.width * 0.2,
                    child: Text(
                      data['nama_sesi'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.03,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 4,
                    ),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
