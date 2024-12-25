import 'package:Grademaster/Pages/index.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SoalAssesmen extends StatefulWidget {
  final String id;
  final String waktuMulai;
  final String waktuSelesai;
  final String jadwal;
  final String idmatkul;

  const SoalAssesmen({
    super.key,
    required this.id,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.jadwal,
    required this.idmatkul,
  });

  @override
  State<SoalAssesmen> createState() => _SoalAssesmenState();
}

class _SoalAssesmenState extends State<SoalAssesmen> {
  late DateTime waktuMulai;
  late DateTime waktuSelesai;
  late String matkul;
  late Duration sisaWaktu;
  late String jadwal;
  Timer? timer;

  final storage = FlutterSecureStorage(); // Untuk menyimpan token
  String? token; // Untuk menyimpan token yang diambil
  String? idPelajar; // Store idPelajar here

  @override
  void initState() {
    super.initState();
    jadwal = widget.jadwal; // Set jadwal from widget
    _initWaktu();
    _loadData(); // Load token dan idPelajar secara bersamaan
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
    } catch (e) {
      print('Error mengambil data dari storage: $e');
    }
  }

  void _initWaktu() {
    final now = DateTime.now();
    final format = DateFormat('HH:mm:ss');

    waktuMulai = DateTime(
      now.year,
      now.month,
      now.day,
      format.parse(widget.waktuMulai).hour,
      format.parse(widget.waktuMulai).minute,
      format.parse(widget.waktuMulai).second,
    );

    waktuSelesai = DateTime(
      now.year,
      now.month,
      now.day,
      format.parse(widget.waktuSelesai).hour,
      format.parse(widget.waktuSelesai).minute,
      format.parse(widget.waktuSelesai).second,
    );

    sisaWaktu = waktuSelesai.difference(DateTime.now());

    if (sisaWaktu.isNegative) {
      _handleWaktuHabis();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        sisaWaktu = waktuSelesai.difference(DateTime.now());

        if (sisaWaktu.isNegative) {
          _handleWaktuHabis();
        }
      });
    });
  }

  void _handleWaktuHabis() {
    timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Waktu Habis'),
          content: const Text('Waktu pengerjaan soal telah habis.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = _formatDuration(sisaWaktu);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Soal Assesmen'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Sisa Waktu: $formattedTime',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: idPelajar == null
          ? const Center(child: CircularProgressIndicator())
          : ListSoal(
              idPelajar: idPelajar!,
              id: widget.id,
              jadwal: widget.jadwal,
              matkul: widget.idmatkul,
              token: token ?? "",
            ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}

class ListSoal extends StatefulWidget {
  final String id;
  final String jadwal;
  final String token;
  final String idPelajar;
  final String matkul;

  const ListSoal({
    super.key,
    required this.matkul,
    required this.id,
    required this.jadwal,
    required this.token,
    required this.idPelajar,
  });

  @override
  State<ListSoal> createState() => _ListSoalState();
}

class _ListSoalState extends State<ListSoal> {
  List<dynamic> _soal = [];
  List<int?> _selectedAnswers = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1/note_app/soal_ujian/list.php?id=${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map && jsonResponse['success'] == true) {
          final validData = (jsonResponse['data'] as List)
              .where((element) => element is Map<String, dynamic>)
              .toList();

          setState(() {
            _soal = validData;
            _selectedAnswers = List.filled(_soal.length, null);
            _isLoading = false;
          });
        }
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
    return Scaffold(
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
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: _currentIndex > 0
                                    ? _previousQuestion
                                    : null,
                                child: Text(
                                  'Sebelumnya',
                                  style: TextStyle(
                                      color: OwnColor.colors['Puith']),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: OwnColor.colors['BiruTua'],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // Membuat tombol dengan sudut tumpul
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: _currentIndex < _soal.length - 1
                                    ? _nextQuestion
                                    : _submit,
                                child: Text(
                                  _currentIndex < _soal.length - 1
                                      ? 'Selanjutnya'
                                      : 'Selesai',
                                  style: TextStyle(
                                      color: OwnColor.colors['Putih']),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: OwnColor.colors['Hijau'],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15), // Membuat tombol dengan sudut tumpul
                                  ),
                                ),
                              ),
                            ),
                          )
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
                jawaban: jawaban
                    .where((item) =>
                        item is Map && item['keterangan_pilihan'] is String)
                    .map<String>((item) => item['keterangan_pilihan'] as String)
                    .toList(),
                selectedAnswer: _selectedAnswers[_currentIndex],
                onAnswerSelected: _updateSelectedAnswer,
              ),
          ],
        ),
      ),
    );
  }

  void _updateSelectedAnswer(int? selectedIndex) {
    setState(() {
      _selectedAnswers[_currentIndex] = selectedIndex;
    });
  }

  void _previousQuestion() {
    setState(() {
      _currentIndex--;
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentIndex++;
    });
  }

  void _submit() async {
    int totalScore = 0; // Variabel untuk total poin
    int correctAnswers = 0; // Variabel untuk jumlah jawaban benar
    int incorrectAnswers = 0; // Variabel untuk jumlah jawaban salah

    for (int i = 0; i < _soal.length; i++) {
      final selectedIndex = _selectedAnswers[i];
      if (selectedIndex != null) {
        final selectedAnswer = _soal[i]['jawaban'][selectedIndex];

        if (selectedAnswer['benar_salah'] == "1") {
          correctAnswers++; // Tambah jawaban benar
          final poin = int.tryParse(_soal[i]['poin']) ?? 0;
          totalScore += poin;
        } else {
          incorrectAnswers++; // Tambah jawaban salah
        }
      }
    }

    // Mengambil waktu saat ini
    final waktuSubmit = DateTime.now().toIso8601String();

    final data_rekap = {
      'id_pelajar': widget.idPelajar,
      'id_jadwal': widget.jadwal,
      'total_nilai': totalScore, // Kirim 0 jika nilainya nol
      'waktu_selesai': waktuSubmit,
      'id_matkul': widget.matkul
    };

    try {
      final responseRekapitulasi = await http.post(
        Uri.parse('http://127.0.0.1/note_app/rekapitulasi/create.php'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(data_rekap),
      );

      if (responseRekapitulasi.statusCode == 200) {
        final responseBodyRekapitulasi = jsonDecode(responseRekapitulasi.body);

        if (responseBodyRekapitulasi['success'] == true) {
          // Menampilkan hasil ujian
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Hasil Akhir'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Skor Anda: $totalScore'), // Tampilkan skor
                  Text('Jawaban Benar: $correctAnswers'),
                  Text('Jawaban Salah: $incorrectAnswers'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Index(), // Halaman utama
                      ),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: ${responseBodyRekapitulasi['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: ${responseRekapitulasi.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }
}

class PilihanJawaban extends StatelessWidget {
  final List<String> jawaban;
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
      children: List<Widget>.generate(jawaban.length, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: RadioListTile<int>(
            title: Text(jawaban[index]),
            value: index,
            groupValue: selectedAnswer,
            onChanged: onAnswerSelected,
          ),
        );
      }),
    );
  }
}
