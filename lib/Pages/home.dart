import 'dart:convert';
import 'package:Grademaster/Pages/assesment/description.dart';
import 'package:Grademaster/Pages/pengajar/rekap/enroll.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
              Center(
                child: Text(
                  'Beranda',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: OwnColor.colors['Putih'],
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
          color: OwnColor.colors['Biru'],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: FloatingActionButton.extended(
                    backgroundColor: OwnColor.colors['Putih'],
                    onPressed: () {},
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: OwnColor.colors['Hijau'],
                      ),
                      child:
                          Icon(Icons.groups, color: OwnColor.colors['Putih']),
                    ),
                    label: Text('Kelas'))),
            SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: FloatingActionButton.extended(
                    backgroundColor: OwnColor.colors['Putih'],
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      EnrollPage()))
                        },
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: OwnColor.colors['Hijau'],
                      ),
                      child: Icon(
                        Icons.menu_book_rounded,
                        color: OwnColor.colors['Putih'],
                      ),
                    ),
                    label: Text('Pelajaran'))),
          ],
        ));
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

  final storage = FlutterSecureStorage(); // Untuk menyimpan token
  String? token; // Untuk menyimpan token yang diambil
  String? idPelajar; // Store idPelajar here
  String? idMatkul; // Store id_matkul here

  @override
  void initState() {
    super.initState();
    _loadData(); // Load token and idPelajar first
  }

  Future<void> _loadData() async {
    try {
      final storedToken = await storage.read(key: 'user_token');
      final storedId = await storage.read(key: 'user_id');

      setState(() {
        token = storedToken;
        idPelajar = storedId;
      });

      print('Token: $token');
      print('ID Pelajar: $idPelajar');

      // After loading the data, get the id_matkul
      if (idPelajar != null) {
        await _getMatkul(); // Get the id_matkul from the first API
      }
    } catch (e) {
      print('Error mengambil data dari storage: $e');
    }
  }

  Future<void> _getMatkul() async {
    try {
      final response = await http.get(Uri.parse(
          "http://127.0.0.1/note_app/matakuliah/getmatkul.php?id_pelajar=$idPelajar"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          // Assuming the response contains a list of courses and we want to get the first one
          final firstMatkul =
              jsonResponse['data'][0]; // Adjust this if you want to handle more
          setState(() {
            idMatkul = firstMatkul['id_matkul'].toString();
          });

          // Call the second API after getting id_matkul
          if (idMatkul != null) {
            await _getData(idMatkul!); // Pass the id_matkul to _getData
          }
        } else {
          print("API Error: ${jsonResponse['message'] ?? 'No courses found'}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> _getData(String idMatkul) async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://127.0.0.1/note_app/sesi/list.php?id_pelajar=$idPelajar&&id_matkul=$idMatkul"),
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
      return const Center(child: Text('Belum Enroll Mata Kuliah nih'));
    }
    if (_get.isEmpty) {
      return const Center(child: Text("Tidak ada Asesmen"));
    }

    print("Data available: $_get");

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

    // Ambil tanggal saat ini
    DateTime currentDate = DateTime.now();

    // Ambil tanggal dari data (pastikan formatnya sesuai dengan yang diterima dari DB)
    DateTime assesmentDate = DateTime.parse(data['tanggal']);

    // Bandingkan tanggal saat ini dengan tanggal assesmen
    bool isPastDate = currentDate.isAfter(assesmentDate);

    return Visibility(
      visible: !isPastDate, // Menyembunyikan jika tanggal sudah lewat
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            elevation: MaterialStateProperty.all(2),
          ),
          onPressed: () {
            final arguments = {
              'id_jadwal': data['id_jadwal'].toString(),
              'id_assesmen': data['id_assesmen'].toString(),
              'nama_sesi': data['nama_assesmen'],
              'keterangan': data['ket_assesmen'],
              'tanggal': data['tanggal'],
              'grade_pass': data['grade_pass'],
              'waktu_mulai': data['waktu_mulai'],
              'waktu_selesai': data['waktu_selesai'],
              'id_matkul': data['id_matkul'].toString(),
            };

            // Print untuk debug data yang dikirim
            print('Arguments: $arguments');

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
                                  width:
                                      MediaQuery.of(context).size.width * 0.19,
                                  height:
                                      MediaQuery.of(context).size.width * 0.12,
                                  child: Text(
                                    data['nama_assesmen'] ?? 'Unknown',
                                    style: GoogleFonts.poppins(
                                      fontSize: screenSize.width * 0.027,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
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
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.023,
                                  ),
                                ))
                          ],
                        )),
                    Container(
                      width: screenSize.width * 0.1,
                      height: screenSize.width * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: OwnColor.colors['Hijau'],
                          boxShadow: [
                            customBoxShadow(
                                opacity: 0.1,
                                blurRadius: 4,
                                spreadRadius: 2,
                                offset: const Offset(0, 3))
                          ]),
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
                          size: screenSize.width * 0.02,
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        Text(data['tanggal'] ?? '-',
                            style: GoogleFonts.poppins(
                                fontSize: screenSize.width * 0.02)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Passing Grade: ',
                          style: GoogleFonts.poppins(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02),
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        Text(data['grade_pass'] ?? '-',
                            style: GoogleFonts.poppins(
                                fontSize: screenSize.width * 0.02)),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
