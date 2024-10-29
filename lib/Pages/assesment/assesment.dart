import 'package:flutter/material.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';
// TODO: add flutter_svg to pubspec.yaml

class AssesmentPage extends StatelessWidget {
  static const nameRoute = '/assesmentpage';

  const AssesmentPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 90),
          child: SafeArea(
              child: Stack(
            children: [
              Container(
                child: Positioned(
                  top: 30,
                  left: 20,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
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
                child: Text('Beranda',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            OwnForm(
                obsecureText: false,
                hintText: 'Fisika Dasar',
                labelText: 'Nama Mata Pelajaran'),
            OwnForm(obsecureText: false, hintText: '', labelText: 'Deskripsi'),
            OwnForm(obsecureText: false, hintText: '', labelText: 'Durasi'),
            OwnForm(obsecureText: false, hintText: '', labelText: 'Tanggal'),
            OwnForm(obsecureText: false, hintText: '', labelText: 'Pukul'),
            OwnForm(
                obsecureText: false, hintText: '', labelText: 'Tengat Waktu'),
            BigButtonG(
              label: 'Tambah Assesmen',
            ),
            Answer(jawaban: 'KAOWDNOAUHBKDAKSJDNKASN')
          ],
        ),
      ),
    );
  }
}