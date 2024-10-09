import 'package:flutter/material.dart';
import 'package:grademaster/Pages/register.dart';
import 'Pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GradeMaster',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );}}