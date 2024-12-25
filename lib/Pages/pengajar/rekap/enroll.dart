import 'dart:convert';
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

  final storage = FlutterSecureStorage(); // Untuk menyimpan token

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
          SnackBar(content: Text("Successfully enrolled in the course!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to enroll in the course.")),
        );
      }
    } catch (e) {
      print("Error enrolling in course: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enroll in Courses"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: matkulList.length,
              itemBuilder: (context, index) {
                final matkul = matkulList[index];
                return ListTile(
                  title: Text(matkul['nama_matkul']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _enrollInMatkul(int.parse(matkul['id_matkul']
                          .toString())); // Ensure it's passed as int
                    },
                    child: Text("Enroll"),
                  ),
                );
              },
            ),
    );
  }
}
