import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PengajarTerdaftar extends StatefulWidget {
  static const nameRoute = '/editassesment';

  const PengajarTerdaftar({super.key});

  @override
  _PengajarTerdaftarState createState() => _PengajarTerdaftarState();
}

class _PengajarTerdaftarState extends State<PengajarTerdaftar> {
  bool _isLoading = true;
  List<dynamic> studentData = []; // Change to a List to store multiple students

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  // Fetch student data from the API
  Future<void> _fetchStudentData() async {
    try {
      final response = await http
          .get(Uri.parse("http://127.0.0.1/note_app/pengajar/pengajar.php"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true &&
            jsonResponse['data'] is List &&
            jsonResponse['data'].isNotEmpty) {
          setState(() {
            studentData = jsonResponse['data']; // Store the entire list
            _isLoading = false;
          });
        } else {
          print("Error: Data format is incorrect or empty.");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching student data: $e");
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
                child: Text('Pengajar Terdaftar',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: studentData.map<Widget>((student) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStudentInfo(
                                    "Nama Lengkap", student['nama_lengkap']),
                                _buildStudentInfo(
                                    "Nomor Telpon", student['no_telp']),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStudentInfo(
                                    "Kelamin", student['kelamin']),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(), // Loop through all students
              ),
      ),
    );
  }

  // Helper method to build each student info
  Widget _buildStudentInfo(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label:",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
