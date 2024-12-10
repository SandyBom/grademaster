import 'package:flutter/material.dart';
import 'package:grademaster/Pages/assesment/assesment.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';

class DescriptionPage extends StatelessWidget {
  static const nameRoute = '/descriptionpage';

  final Map<String, dynamic> arguments;

  const DescriptionPage({super.key, required this.arguments});

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
                arguments['nama_sesi'] ?? '',
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
              value: arguments['grade_pass'] ?? '',
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
              value: arguments['tanggal'] ?? '',
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
          BigButtonG(
            id: arguments['id'] ?? '',
            label: 'Kerjakan Assesmen',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssesmentPage(),
                ),
              );
            },
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
