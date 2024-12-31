import 'dart:convert';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EnrollPage extends StatefulWidget {
  const EnrollPage({super.key});

  @override
  _EnrollPageState createState() => _EnrollPageState();
}

class _EnrollPageState extends State<EnrollPage> {
  List<dynamic> matkulList = [];
  bool _isLoading = true;
  String? token;
  String? idPelajar;

  final storage = const FlutterSecureStorage(); // Untuk menyimpan token

  @override
  void initState() {
    super.initState();
    _loadData();
    _getMatkul();
  }

  // Load token and student ID
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
    } catch (e) {
      print('Error mengambil data dari storage: $e');
    }
  }

  // Fetch matakuliah (courses) from API
  Future<void> _getMatkul() async {
    try {
      final response = await http
          .get(Uri.parse("http://127.0.0.1/note_app/matakuliah/list.php"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          setState(() {
            matkulList = jsonResponse['data'];
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

  // Enroll in a matkul (course)
  Future<void> _enrollInMatkul(int idMatkul) async {
    if (idPelajar == null) {
      print('No student ID available.');
      return;
    }

    try {
      int parsedIdPelajar = int.parse(idPelajar!); // Convert String to int

      final response = await http.post(
        Uri.parse("http://127.0.0.1/note_app/matakuliah/enroll.php"),
        body: {
          'id_pelajar': parsedIdPelajar.toString(),
          'id_matkul': idMatkul.toString(),
        },
      );

      // Log the raw response body for debugging
      print("Response Body: ${response.body}");

      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Successfully enrolled in the course!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to enroll in the course.")),
        );
      }
    } catch (e) {
      print("Error enrolling in course: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 40),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
                  image: DecorationImage(
                    image: AssetImage('ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Center(
                child: Text('Enroll Mata Kuliah',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Call Navigator.pop() to go back to the previous screen
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: matkulList.length,
              itemBuilder: (context, index) {
                final matkul = matkulList[index];
                return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(matkul['nama_matkul']), // Menampilkan nama_matkul
                        const SizedBox(
                            height:
                                5), // Memberi jarak antara nama_matkul dan nama_prodi
                        Text(
                          matkul['nama_prodi'], // Menampilkan nama_prodi
                          style: const TextStyle(
                            fontSize:
                                14, // Ukuran font lebih kecil untuk nama_prodi
                            color:
                                Colors.grey, // Warna abu-abu untuk nama_prodi
                          ),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                OwnColor.colors['Hijau'], // Warna tombol hijau
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  15), // Membuat tombol dengan sudut tumpul
                            ),
                          ),
                          onPressed: () {
                            _enrollInMatkul(
                                int.parse(matkul['id_matkul'].toString()));
                            // Ensure it's passed as int
                          },
                          child: Text(
                            "Enroll",
                            style: TextStyle(
                              color: OwnColor.colors['Putih'],
                            ),
                          ),
                        )));
              },
            ),
    );
  }
}
