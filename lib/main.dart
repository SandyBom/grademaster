import 'package:flutter/material.dart';
import 'package:grademaster/Pages/assesment/addsoal.dart';
import 'package:grademaster/Pages/assesment/assesment.dart';
import 'package:grademaster/Pages/assesment/description.dart';
import 'package:grademaster/Pages/assesment/rekapsoal.dart';
import 'package:grademaster/Pages/assesment/soal.dart';
import 'package:grademaster/Pages/home.dart';
import 'package:grademaster/Pages/pengajar/edit_assesment.dart';
import 'package:grademaster/Pages/pengajar/pengajar_home.dart';
import 'package:grademaster/Pages/signin/login.dart';
import 'package:grademaster/Pages/trial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        LoginPage.nameRoute: (context) => LoginPage(),
        AssesmentPage.nameRoute: (context) => AssesmentPage(),
        DescriptionPage.nameRoute: (context) => DescriptionPage(
              id: '',
              keterangan: '',
            ),
        EditAsessment.nameRoute: (context) => EditAsessment(),
        SoalAssesmen.nameRoute: (context) => SoalAssesmen(),
        HomePengajar.nameRoute: (context) => HomePengajar(),
        TrialMaterial.nameRoute: (context) => TrialMaterial(),
        HomePelajar.nameRoute: (context) => HomePelajar(),
        RekapSoal.nameRoute: (context) => RekapSoal(),
        AddSoal.nameRoute: (context) => AddSoal()
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/description') {
          final keterangan = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DescriptionPage(
              id: '',
              keterangan: keterangan,
            ),
          );
        }
        return null; // return null or default route if not matched
      },
      title: 'GradeMaster',
      debugShowCheckedModeBanner: false,
      home: HomePelajar(),
    );
  }
}
