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
  const MyApp({super.key});

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
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool isLoading = false;

  Future<void> navigateToNextPage() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulasi proses loading

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
          MaterialPageRoute(builder: (BuildContext context) => const Index()),
        );
      } else if (role == 'pengajar') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const IndexPengajar()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Peran pengguna tidak dikenali.')),
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
            const SizedBox(height: 20),
            Image.asset(
              'logo.png',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 260,
              child: const Text(
                'Solusi terbaik untuk kebutuhan Ujian di Kelas Kamu!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
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
