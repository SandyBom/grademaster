import 'package:flutter/material.dart';
import 'package:grademaster/Pages/assesment/addsoal.dart';
import 'package:grademaster/Pages/assesment/assesment.dart';
import 'package:grademaster/Pages/assesment/description.dart';
import 'package:grademaster/Pages/assesment/rekapsoal.dart';
import 'package:grademaster/Pages/assesment/review.dart';
import 'package:grademaster/Pages/assesment/soal.dart';
import 'package:grademaster/Pages/home.dart';
import 'package:grademaster/Pages/pengajar/edit_assesment.dart';
import 'package:grademaster/Pages/pengajar/pengajar_home.dart';
import 'package:grademaster/Pages/pengajar/rekap/list_jadwal.dart';
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
        HomePengajar.nameRoute: (context) => HomePengajar(),
        TrialMaterial.nameRoute: (context) => TrialMaterial(),
        HomePelajar.nameRoute: (context) => HomePelajar(),
        HomePengajar.nameRoute: (context) => HomePengajar(),
        AddSoal.nameRoute: (context) => AddSoal(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case DescriptionPage.nameRoute:
            // Pastikan data dikirimkan via arguments
            if (settings.arguments != null) {
              final data = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => DescriptionPage(
                  arguments: data,
                ),
              );
            } else {
              // Tangani jika arguments tidak ada
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text("Data tidak ditemukan")),
                ),
              );
            }
          default:
            return null; // Jika tidak cocok, biarkan `null`
        }
      },
      title: 'GradeMaster',
      debugShowCheckedModeBanner: false,
      home: HomePengajar(),
    );
  }
}
