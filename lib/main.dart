import 'package:flutter/material.dart';
import 'package:grademaster/Pages/assesment/addsoal.dart';
import 'package:grademaster/Pages/assesment/assesment.dart';
import 'package:grademaster/Pages/assesment/description.dart';
import 'package:grademaster/Pages/assesment/soal.dart';
import 'package:grademaster/Pages/home.dart';
import 'package:grademaster/Pages/pengajar/edit_assesment.dart';
import 'package:grademaster/Pages/signin/login.dart';
import 'package:grademaster/Pages/signin/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/main',
      routes: {
        HomePage.nameRoute: (context) => HomePage(),
        RegisterPage.nameRoute: (context) => RegisterPage(),
        LoginPage.nameRoute: (context) => LoginPage(),
        AssesmentPage.nameRoute: (context) => AssesmentPage(),
        DescriptionPage.nameRoute: (context) => DescriptionPage(),
        EditAsessment.nameRoute: (context) => EditAsessment(),
        SoalAssesmen.nameRoute: (context) => SoalAssesmen(),
      },
      title: 'GradeMaster',
      debugShowCheckedModeBanner: false,
      home: SoalAssesmen(),
    );
  }
}
