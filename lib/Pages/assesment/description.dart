import 'package:Grademaster/Pages/assesment/soal.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For decoding JSON
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class DescriptionPage extends StatefulWidget {
  static const nameRoute = '/descriptionpage';
  final Map<String, dynamic> arguments;

  const DescriptionPage({super.key, required this.arguments});

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  bool isAssesmenSubmitted = false;
  String? token;
  String? idPelajar;

  @override
  void initState() {
    super.initState();
    checkAssesmenStatus();
  }

  Future<void> checkAssesmenStatus() async {
    try {
      // Read token and idPelajar from Secure Storage
      final storedToken = await storage.read(key: 'user_token');
      final storedId = await storage.read(key: 'user_id');
      final idAssesmen = widget.arguments['id_assesmen']; // Dapatkan id asesmen

      setState(() {
        token = storedToken;
        idPelajar = storedId;
      });

      print('Token: $token');
      print('ID Pelajar: $idPelajar');
      print('ID Assesmen: $idAssesmen');
    } catch (e) {
      print('Error mengambil data dari storage: $e');
    }

    if (idPelajar != null && widget.arguments['id_assesmen'] != null) {
      // API URL to check assessment status for specific asesmen
      final url = Uri.parse(
        'http://127.0.0.1/note_app/rekapitulasi/status.php?id_pelajar=$idPelajar&id_assesmen=${widget.arguments['id_assesmen']}',
      );

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Cek apakah data 'data' berisi asesmen yang sudah diselesaikan oleh id_pelajar
        if (data['status'] == 'success' && data['data'].isNotEmpty) {
          bool isSubmitted = false;

          // Loop melalui data asesmen untuk memeriksa apakah id_pelajar ada di dalamnya
          for (var asesmen in data['data']) {
            if (asesmen['id_pelajar'].toString() == idPelajar.toString()) {
              // Jika ditemukan, maka asesmen sudah diselesaikan
              isSubmitted = true;
              break;
            }
          }

          // Update status asesmen berdasarkan hasil pengecekan
          setState(() {
            isAssesmenSubmitted = isSubmitted; // True jika sudah diselesaikan
          });
        } else {
          // Jika data kosong atau statusnya bukan success
          setState(() {
            isAssesmenSubmitted = false; // Asesmen belum dikerjakan
          });
        }
      } else {
        // Jika request gagal
        setState(() {
          isAssesmenSubmitted = false; // Asesmen belum dikerjakan
        });
      }
    } else {
      // Menangani kasus jika idPelajar atau idAssesmen tidak ada
      print('ID Pelajar atau ID Assesmen tidak ditemukan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 20),
            _buildBody(context, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: OwnColor.colors['Biru'],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: DataTable(
          columns: [
            DataColumn(
              label: Text(
                widget.arguments['nama_sesi'] ?? '',
                style: TextStyle(
                  color: OwnColor.colors['Putih'],
                  fontWeight: FontWeight.w800,
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                ),
              ),
            ),
            DataColumn(label: Text('')),
          ],
          rows: [
            _buildDataRow(
              context,
              icon: Icons.info_outline,
              label: 'Passing Grade',
              value: widget.arguments['grade_pass'] ?? '',
            ),
            _buildDataRow(
              context,
              icon: Icons.timer_outlined,
              label: 'Durasi Pengerjaan',
              value: '25 menit',
            ),
            _buildDataRow(
              context,
              icon: Icons.timer_off_outlined,
              label: 'Tanggal Tenggat',
              value: widget.arguments['tanggal'] ?? '',
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return DataRow(cells: [
      DataCell(
        Row(
          children: [
            Icon(
              icon,
              color: OwnColor.colors['Putih'],
              size: MediaQuery.of(context).size.width * 0.025,
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: OwnColor.colors['Putih'],
                fontSize: MediaQuery.of(context).size.width * 0.025,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          value,
          style: TextStyle(
            color: OwnColor.colors['Putih'],
            fontSize: MediaQuery.of(context).size.width * 0.025,
          ),
        ),
      ),
    ]);
  }

  Widget _buildBody(BuildContext context, double screenHeight) {
    return Container(
      height: screenHeight < 760
          ? MediaQuery.of(context).size.width * 0.5
          : MediaQuery.of(context).size.width * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Description(),
          // Only show the BigButtonG if the assessment hasn't been submitted
          if (!isAssesmenSubmitted)
            BigButtonG(
              jadwal: widget.arguments['id_jadwal'] ?? 'Default Jadwal',
              id: widget.arguments['id_assesmen'] ?? '',
              waktu_m: widget.arguments['waktu_mulai'] ?? '00:00',
              waktu_s: widget.arguments['waktu_selesai'] ?? '00:00',
              matkul: widget.arguments['id_matkul'],
              label: 'Kerjakan Assesmen',
              onPressed: isAssesmenSubmitted
                  ? null // Disable button if already submitted
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SoalAssesmen(
                            idmatkul: widget.arguments['id_matkul'],
                            jadwal: widget.arguments['id_jadwal'] ??
                                'Default Jadwal',
                            id: widget.arguments['id_assesmen'] ?? '1',
                            waktuMulai:
                                widget.arguments['waktu_mulai'] ?? '00:00',
                            waktuSelesai:
                                widget.arguments['waktu_selesai'] ?? '00:00',
                          ),
                        ),
                      );
                    },
            ),
          if (isAssesmenSubmitted)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Anda sudah menyelesaikan assesmen ini.',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Syarat dan Ketentuan Assesmen \n',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Peserta diwajibkan untuk menyelesaikan assesmen dalam waktu 60 menit sejak dimulai, dengan 30 soal pilihan ganda yang mencakup berbagai topik yang telah dipelajari. Setiap soal memiliki bobot nilai yang sama, dan tidak ada penalti untuk jawaban yang salah, namun soal yang tidak dijawab akan dianggap tidak sah. Assesmen ini harus diselesaikan dan dikirimkan sebelum tanggal 15 Desember 2024, pukul 23:59. Keterlambatan dalam pengumpulan jawaban akan membuat hasil assesmen dianggap tidak valid, sehingga pastikan untuk menyelesaikan dan mengirimkan jawaban tepat waktu.',
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.025,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
