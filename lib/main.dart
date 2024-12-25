import 'package:Grademaster/Pages/index.dart';
import 'package:Grademaster/Pages/index_pengajar.dart';
import 'package:Grademaster/Pages/signin/login.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  bool isLoading = false;

  Future<void> navigateToNextPage() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1)); // Simulasi proses loading

    String? token;
    String? role;

    try {
      // Baca token dan role pengguna dari storage
      token = await _storage.read(key: 'user_token');
      role = await _storage.read(key: 'user_role');
    } catch (e) {
      print('Error reading secure storage: $e');
    }

    setState(() {
      isLoading = false;
    });

    if (token != null && token.isNotEmpty) {
      if (role == 'pelajar') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Index()),
        );
      } else if (role == 'pengajar') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => IndexPengajar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Peran pengguna tidak dikenali.')),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'logo.png',
              width: 300,
              height: 300,
            ),
            SizedBox(height: 10),
            Container(
              width: 260,
              child: Text(
                'Solusi terbaik untuk kebutuhan Ujian di Kelas Kamu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : navigateToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OwnColor.colors['Biru'],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: OwnColor.colors['Putih'],
                        )
                      : Text(
                          'Mulai Sekarang!',
                          style: TextStyle(color: OwnColor.colors['Putih']),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
