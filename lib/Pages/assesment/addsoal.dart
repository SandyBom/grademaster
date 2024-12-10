import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grademaster/Pages/pengajar/pengajar_home.dart';
import 'package:http/http.dart' as http;

class AddSoal extends StatefulWidget {
  static const nameRoute = '/addsoal';
  const AddSoal({super.key});

  @override
  _AddSoalState createState() => _AddSoalState();
}

class _AddSoalState extends State<AddSoal> {
  final List<Map<String, dynamic>> _questions = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _poinController = TextEditingController();

  final Map<String, TextEditingController> _answerControllers = {
    'A': TextEditingController(),
    'B': TextEditingController(),
    'C': TextEditingController(),
    'D': TextEditingController(),
    'E': TextEditingController(),
  };

  String _correctAnswer = 'A';
  List<Map<String, dynamic>> _assesmenList = [];
  String? _selectedAssesmen;

  @override
  void initState() {
    super.initState();
    _fetchAssesmenList();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _poinController.dispose();
    _answerControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  Future<void> _fetchAssesmenList() async {
    final url = Uri.parse('http://127.0.0.1/note_app/sesi/list.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          final List<dynamic> data = jsonResponse['data'];
          setState(() {
            _assesmenList = data.map((item) {
              return {
                "id_assesmen": item['id_assesmen'],
                "nama_assesmen": item['nama_assesmen']
              };
            }).toList();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat data asesmen')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saat mengambil data: $e')),
      );
    }
  }

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      final newQuestion = {
        'id': _selectedAssesmen,
        'soal': _questionController.text,
        'poin': _poinController.text,
        'jawaban': _answerControllers
            .map((key, controller) => MapEntry(key, controller.text)),
        'correctAnswer': _correctAnswer,
      };
      setState(() {
        _questions.add(newQuestion);
        _resetForm();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Soal berhasil ditambahkan ke daftar')),
      );
    }
  }

  Future<void> _submitQuestions() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tambahkan setidaknya satu soal')),
      );
      return;
    }

    for (final question in _questions) {
      final body = {
        'id_assesmen': question['id'],
        'soal': question['soal'],
        'poin': question['poin'],
        'jawaban':
            (question['jawaban'] as Map<String, dynamic>).entries.map((entry) {
          return {
            'keterangan_pilihan': entry.value,
            'benar_salah': entry.key == question['correctAnswer'] ? "1" : "0"
          };
        }).toList(),
      };

      print("Mengirim data soal:");
      print(jsonEncode(body));

      final url = Uri.parse('http://127.0.0.1/note_app/soal_ujian/create.php');

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );
        print("Respons server: ${response.body}");

        if (response.statusCode != 200) {
          throw Exception('HTTP Error: ${response.statusCode}');
        }
      } catch (e) {
        print("Error saat mengirim soal: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengirim soal: $e')),
        );
      }
    }

    // Menampilkan Snackbar setelah berhasil mengirim soal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Semua soal berhasil dikirim!')),
    );

    // Menghapus soal yang sudah dikirim
    setState(() {
      _questions.clear();
    });

    // Navigasi ke halaman HomePengajar setelah soal berhasil dikirim
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePengajar()),
    );
  }

  void _resetForm() {
    _questionController.clear();
    _poinController.clear();
    _answerControllers.forEach((key, controller) => controller.clear());
    _correctAnswer = 'A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Soal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedAssesmen,
                    items:
                        _assesmenList.map<DropdownMenuItem<String>>((assesmen) {
                      return DropdownMenuItem<String>(
                        value: assesmen['id_assesmen'],
                        child: Text(assesmen['nama_assesmen']),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedAssesmen = value),
                    decoration: InputDecoration(labelText: 'Pilih ID Assesmen'),
                  ),
                  TextFormField(
                    controller: _questionController,
                    decoration: InputDecoration(labelText: 'Pertanyaan'),
                  ),
                  TextFormField(
                    controller: _poinController,
                    decoration: InputDecoration(labelText: 'Poin'),
                    keyboardType: TextInputType.number,
                  ),
                  ..._answerControllers.entries
                      .map((entry) => TextFormField(
                            controller: entry.value,
                            decoration: InputDecoration(
                                labelText: 'Jawaban ${entry.key}'),
                          ))
                      .toList(),
                  DropdownButtonFormField<String>(
                    value: _correctAnswer,
                    items: _answerControllers.keys
                        .map((key) => DropdownMenuItem(
                            value: key, child: Text('Jawaban $key')))
                        .toList(),
                    onChanged: (value) => setState(
                        () => value != null ? _correctAnswer = value : null),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addQuestion,
                        child: Text('Tambah Soal'),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _questions.isEmpty ? null : _submitQuestions,
                        child: Text('Submit Soal'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Daftar Soal:'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return ListTile(
                  title: Text(question['soal']),
                  subtitle: Text('Poin: ${question['poin']}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
