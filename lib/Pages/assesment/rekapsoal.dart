import 'dart:convert';
import 'package:Grademaster/Pages/index_pengajar.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
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
  List<Map<String, dynamic>> _soalList = [];

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

  Future<void> _saveEditedData() async {
    final url =
        Uri.parse('http://127.0.0.1/note_app/soal_ujian/update_soal.php');
    final idAssesmen = widget.arguments['id_assesmen'];

    try {
      for (var soal in _soalList) {
        final soalData = {
          'id_assesmen': idAssesmen.toString(),
          'id_soal': soal['id_soal'].toString(),
          'soal': soal['soal'],
          'jawaban': jsonEncode(soal['jawaban']), // JSON-encode jawaban
        };

        final response = await http.post(
          url,
          body: soalData,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success'] == true) {
            print('Soal ${soal['id_soal']} berhasil disimpan.');
          } else {
            print('Error dari server: ${data['message']}');
          }
        } else {
          print('Error: HTTP ${response.statusCode}');
        }
      }

      // Tampilkan notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data soal berhasil disimpan!')),
      );

      // Kembali ke halaman HomePengajar dan refresh data
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IndexPengajar()));
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
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
                child: Text('Edit Soal',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
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

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: soal['soal'],
                            onChanged: (value) {
                              _soalList[index]['soal'] = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Soal',
                              border: authOutlineInputBorder,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Jawaban:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(jawaban.length, (jawabanIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: TextFormField(
                                      initialValue: jawaban[jawabanIndex]
                                          ['keterangan_pilihan'],
                                      onChanged: (value) {
                                        _soalList[index]['jawaban']
                                                [jawabanIndex]
                                            ['keterangan_pilihan'] = value;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Jawaban',
                                        border: authOutlineInputBorder,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 0,
                                    child: Radio<int>(
                                      value: jawabanIndex,
                                      groupValue: jawaban.indexWhere(
                                          (j) => j['benar_salah'] == 1),
                                      onChanged: (value) {
                                        setState(() {
                                          for (int i = 0;
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
                          }),
                          const SizedBox(height: 16),
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
          _saveEditedData();
          print('Data yang dikirim: ${jsonEncode(_soalList)}');
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
