import 'dart:convert';
import 'package:Grademaster/Pages/index_pengajar.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:Grademaster/Pages/pengajar/pengajar_home.dart';
import 'package:flutter/services.dart';
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
    final url = Uri.parse('http://127.0.0.1/note_app/sesi/list_sesi.php');
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
            const SnackBar(content: Text('Gagal memuat data asesmen')),
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
        const SnackBar(content: Text('Soal berhasil ditambahkan ke daftar')),
      );
    }
  }

  Future<void> _submitQuestions() async {
    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan setidaknya satu soal')),
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
      const SnackBar(content: Text('Semua soal berhasil dikirim!')),
    );

    // Menghapus soal yang sudah dikirim
    setState(() {
      _questions.clear();
    });

    // Navigasi ke halaman HomePengajar setelah soal berhasil dikirim
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IndexPengajar()),
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
    double screenWidth = MediaQuery.of(context).size.width;
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
                child: Text('Tambah Soal',
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
                    decoration: InputDecoration(
                      labelText: 'Nama Assesmen',
                      // Menggunakan parameter labelText
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: authOutlineInputBorder,
                      enabledBorder: authOutlineInputBorder.copyWith(
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Color(0xFF214C7A)),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  TextFormField(
                    controller: _questionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Pertanyaan',
                      // Menggunakan parameter labelText
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: authOutlineInputBorder,
                      enabledBorder: authOutlineInputBorder.copyWith(
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Color(0xFF214C7A)),
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  TextFormField(
                    controller: _poinController,
                    decoration: InputDecoration(
                      labelText: 'Poin',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: authOutlineInputBorder,
                      enabledBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Color(0xFF214C7A)),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Hanya memperbolehkan angka
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  ..._answerControllers.entries.map((entry) => Column(
                        children: [
                          TextFormField(
                            maxLines: null,
                            controller: entry.value,
                            decoration: InputDecoration(
                              labelText: 'Jawaban ${entry.key}',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              border: authOutlineInputBorder,
                              enabledBorder: authOutlineInputBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: authOutlineInputBorder.copyWith(
                                borderSide:
                                    const BorderSide(color: Color(0xFF214C7A)),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: screenWidth *
                                  0.03), // Tambahkan jarak antar TextFormField
                        ],
                      )),
                  SizedBox(height: screenWidth * 0.03),
                  DropdownButtonFormField<String>(
                    value: _correctAnswer,
                    items: _answerControllers.keys
                        .map((key) => DropdownMenuItem(
                            value: key, child: Text('Jawaban $key')))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: 'Pilih Jawaban Benar',
                      // Menggunakan parameter labelText
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      border: authOutlineInputBorder,
                      enabledBorder: authOutlineInputBorder.copyWith(
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Color(0xFF214C7A)),
                      ),
                    ),
                    onChanged: (value) => setState(
                        () => value != null ? _correctAnswer = value : null),
                  ),
                  SizedBox(height: screenWidth * 0.03),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _addQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OwnColor
                                  .colors['Hijau'], // Warna tombol hijau
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Membuat tombol dengan sudut tumpul
                              ),
                            ),
                            child: Text(
                              'Tambah Soal',
                              style: TextStyle(color: OwnColor.colors['Putih']),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 45,
                            child: ElevatedButton(
                              onPressed:
                                  _questions.isEmpty ? null : _submitQuestions,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: OwnColor
                                    .colors['BiruTua'], // Warna tombol hijau
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Membuat tombol dengan sudut tumpul
                                ),
                              ),
                              child: Text(
                                'Submit Soal',
                                style:
                                    TextStyle(color: OwnColor.colors['Putih']),
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Daftar Soal:'),
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
