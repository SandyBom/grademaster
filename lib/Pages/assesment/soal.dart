import 'package:flutter/material.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SoalAssesmen extends StatefulWidget {
  final String id;

  const SoalAssesmen({super.key, required this.id});

  @override
  State<SoalAssesmen> createState() => _SoalAssesmenState();
}

class _SoalAssesmenState extends State<SoalAssesmen> {
  List<dynamic> _soal = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  List<int?> _selectedAnswers =
      []; // Indeks jawaban yang dipilih untuk setiap soal

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1/note_app/soal_ujian/list.php?id=${widget.id}'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map && jsonResponse['success'] == true) {
          setState(() {
            _soal = jsonResponse['data'];
            _selectedAnswers =
                List.filled(_soal.length, null); // Inisialisasi jawaban
            _isLoading = false;
          });
        } else {
          print("Unexpected response format: $jsonResponse");
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

  void _nextQuestion() {
    if (_currentIndex < _soal.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _updateSelectedAnswer(int? selectedIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = selectedIndex;
    });
  }

  // Fungsi untuk submit jawaban
  void _submit() async {
    // Periksa apakah semua soal sudah terjawab
    final unansweredQuestions = <int>[];
    for (int i = 0; i < _selectedAnswers.length; i++) {
      if (_selectedAnswers[i] == null) {
        unansweredQuestions.add(i + 1); // Nomor soal (mulai dari 1)
      }
    }

    if (unansweredQuestions.isNotEmpty) {
      // Tampilkan dialog jika ada soal yang belum dijawab
      _showUnansweredDialog(unansweredQuestions);
      return; // Jangan lanjutkan proses submit
    }

    try {
      // Mengumpulkan jawaban dari soal
      List<Map<String, dynamic>> answers = [];
      for (int i = 0; i < _soal.length; i++) {
        answers.add({
          'soal_id': _soal[i]['id'], // Asumsi soal memiliki 'id'
          'jawaban_id': _selectedAnswers[i],
        });
      }

      // Mengirimkan jawaban ke server menggunakan POST
      final response = await http.post(
        Uri.parse('http://127.0.0.1/note_app/soal_ujian/submit.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': widget.id, // ID ujian yang diambil dari parameter
          'jawaban': answers,
        }),
      );

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['success'] == true) {
          _showResultDialog(responseJson['score']);
        } else {
          _showErrorDialog('Gagal mengirim jawaban. Coba lagi.');
        }
      } else {
        _showErrorDialog(
            'Terjadi kesalahan. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showUnansweredDialog(List<int> unansweredQuestions) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Soal Belum Dijawab'),
          content: Text(
            'Anda belum menjawab soal berikut: ${unansweredQuestions.join(", ")}.\nSilakan jawab semua soal sebelum mengirim.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(int score) {
    print("Submit jawaban: $_selectedAnswers");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hasil Ujian'),
          content: Text('Skor Anda: $score'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    print("Submit jawaban: $_selectedAnswers");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soal Assesmen')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _soal.isEmpty
              ? const Center(child: Text('No soal found.'))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildSoal(_soal[_currentIndex]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            height: 55,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: OwnColor.colors['AbuAbu'],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: _currentIndex > 0
                                  ? _previousQuestion
                                  : null, // Disable jika di soal pertama
                              child: Text('Sebelumnya',
                                  style: TextStyle(
                                      color: OwnColor.colors['Putih'])),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            height: 55,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: OwnColor.colors['BiruTua'],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: _currentIndex < _soal.length - 1
                                  ? _nextQuestion
                                  : _submit, // Jika soal terakhir, tombol submit
                              child: Text(
                                _currentIndex < _soal.length - 1
                                    ? 'Selanjutnya'
                                    : 'Selesai', // Ganti teks tombol
                                style:
                                    TextStyle(color: OwnColor.colors['Putih']),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSoal(dynamic soal) {
    final jawaban = soal['jawaban'] ?? [];
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pertanyaan: ${soal['soal']}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (jawaban.isEmpty)
              const Text('Tidak ada jawaban tersedia.')
            else
              PilihanJawaban(
                jawaban: jawaban,
                selectedAnswer: _selectedAnswers[_currentIndex],
                onAnswerSelected: _updateSelectedAnswer,
              ),
          ],
        ),
      ),
    );
  }
}

class PilihanJawaban extends StatelessWidget {
  final List<dynamic> jawaban;
  final int? selectedAnswer;
  final ValueChanged<int?> onAnswerSelected;

  const PilihanJawaban({
    super.key,
    required this.jawaban,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: jawaban.asMap().entries.map((entry) {
        final index = entry.key;
        final jawaban = entry.value;

        return InkWell(
          onTap: () => onAnswerSelected(index),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(
                  color: selectedAnswer == index ? Colors.blue : Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Radio<int>(
                  value: index,
                  groupValue: selectedAnswer,
                  onChanged: onAnswerSelected,
                ),
                Expanded(
                  child: Text(
                    jawaban['keterangan_pilihan'] ?? 'Kosong',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
