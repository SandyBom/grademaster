import 'package:flutter/material.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';
// TODO: add flutter_svg to pubspec.yaml

class AddSoal extends StatelessWidget {
  static const nameRoute = '/addsoal';

  const AddSoal({super.key});
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
            OwnForm(obsecureText: true, hintText: '', labelText: ''),
            OwnForm(obsecureText: true, hintText: '', labelText: ''),
            SizedBox(
              height: 16,
            ),
            MyForm(valueAnswer: 'A'),
            MyForm(valueAnswer: 'B'),
            MyForm(valueAnswer: 'C'),
            MyForm(valueAnswer: 'D'),
            MyForm(valueAnswer: 'E'),
          ],
        ),
      ),
    );
  }
}
