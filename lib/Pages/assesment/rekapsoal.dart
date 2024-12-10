import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RekapSoal extends StatefulWidget {
  static const nameRoute = '/rekapsoal';

  final Map<String, dynamic> arguments;

  const RekapSoal({super.key, required this.arguments});

  @override
  _RekapSoalState createState() => _RekapSoalState();
}

class _RekapSoalState extends State<RekapSoal> {
  late Future<List<dynamic>> _soalData;
  List<Map<String, dynamic>> _soalList = []; // Menyimpan data soal di state

  @override
  void initState() {
    super.initState();
    final idAssesmen = widget.arguments['id_assesmen'];
    _soalData = _fetchSoalData(idAssesmen);
  }

  Future<List<dynamic>> _fetchSoalData(String idAssesmen) async {
    final url = Uri.parse(
        'http://127.0.0.1/note_app/soal_ujian/rekap_list.php?id_assesmen=$idAssesmen');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] is List) {
          setState(() {
            _soalList = List<Map<String, dynamic>>.from(data['data']);
          });
          return data['data'];
        } else {
          print('Error: ${data['message'] ?? 'Invalid response structure'}');
        }
      } else {
        print('Error: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
    return [];
  }

  // Fungsi untuk menyimpan soal dan jawaban yang telah diubah
  Future<void> _saveEditedData(
      List<Map<String, dynamic>> editedSoalList) async {
    final url =
        Uri.parse('http://127.0.0.1/note_app/soal_ujian/update_soal.php');
    final idAssesmen = widget.arguments['id_assesmen']; // Tambahkan id_assesmen
    try {
      for (var soalData in editedSoalList) {
        final response = await http.post(url, body: {
          'id_assesmen': idAssesmen.toString(),
          'id_soal': soalData['id_soal'].toString(),
          'soal': soalData['soal'],
          'jawaban': jsonEncode(
              soalData['jawaban']), // Kirim jawaban dalam JSON string
        });

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body); // Mencoba mengdecode JSON
            if (data['success'] == true) {
              print('Soal dan jawaban berhasil disimpan!');
            } else {
              print('Error dari server: ${data['message']}');
            }
          } catch (e) {
            print('Error parsing JSON: $e');
            print('Response body: ${response.body}');
          }
        } else {
          print('Error: HTTP ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 90),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
                  image: DecorationImage(
                    image: AssetImage('ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Rekap Soal',
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
      body: FutureBuilder<List<dynamic>>(
          future: _soalData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading data: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _soalList.length,
              itemBuilder: (context, index) {
                final soal = _soalList[index];
                final jawaban = soal['jawaban'] ?? [];

                // Controller untuk soal
                TextEditingController soalController =
                    TextEditingController(text: soal['soal']);

                // Simpan indeks jawaban yang benar
                int? selectedJawabanIndex =
                    jawaban.indexWhere((j) => j['benar_salah'] == 1);

                // List untuk menyimpan kontroler jawaban
                List<Map<String, dynamic>> jawabanData = [];
                for (int i = 0; i < jawaban.length; i++) {
                  jawabanData.add({
                    'controller': TextEditingController(
                        text: jawaban[i]['keterangan_pilihan']),
                    'index': i,
                    'id_pilihan': jawaban[i]
                        ['id_pilihan'], // Menambahkan id_pilihan
                  });
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: soalController,
                            decoration: InputDecoration(
                              labelText: 'Soal',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Jawaban:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...jawabanData.map((data) {
                            int index = data['index'];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: data['controller'],
                                      decoration: InputDecoration(
                                        labelText:
                                            'Jawaban ${String.fromCharCode(65 + index)}',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    flex: 1,
                                    child: Radio<int>(
                                      value: index,
                                      groupValue: selectedJawabanIndex,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedJawabanIndex = value;
                                          // Perbarui nilai "benar_salah" di data jawaban
                                          for (var i = 0;
                                              i < jawaban.length;
                                              i++) {
                                            jawaban[i]['benar_salah'] =
                                                (i == value) ? 1 : 0;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Kumpulkan data soal dan jawaban yang sudah diedit
          List<Map<String, dynamic>> editedSoalList = [];

          for (int index = 0; index < _soalList.length; index++) {
            final soal = _soalList[index];
            final soalController = TextEditingController(
                text: soal['soal']); // Menggunakan controller soal

            List<Map<String, dynamic>> editedJawaban = [];

            // Pastikan setiap jawaban memiliki kontroler teks
            List<TextEditingController> jawabanControllers = soal['jawaban']
                .map<TextEditingController>((jawaban) =>
                    TextEditingController(text: jawaban['keterangan_pilihan']))
                .toList();

            for (int i = 0; i < soal['jawaban'].length; i++) {
              final jawaban = soal['jawaban'][i];
              final controller = jawabanControllers[i];

              // Masukkan jawaban yang telah diedit
              editedJawaban.add({
                'keterangan_pilihan': controller.text,
                'benar_salah': jawaban['benar_salah'],
                'id_pilihan': jawaban['id_pilihan'], // Menambahkan id_pilihan
              });
            }

            editedSoalList.add({
              'id_soal': soal['id_soal'],
              'soal': soalController.text,
              'jawaban': editedJawaban,
            });
          }

          // Simpan perubahan yang telah diedit
          _saveEditedData(editedSoalList);

          // Debugging
          print('Data yang dikirim: ${jsonEncode(editedSoalList)}');
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
