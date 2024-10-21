import 'package:flutter/material.dart';
import 'package:grademaster/Pages/home.dart';
import 'package:grademaster/Pages/login.dart';
import 'package:grademaster/Pages/register.dart';

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
        LoginPage.nameRoute: (context) => LoginPage()
      },
      title: 'GradeMaster',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
