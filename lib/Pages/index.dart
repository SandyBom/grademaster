import 'package:Grademaster/Pages/home.dart';
import 'package:Grademaster/Pages/rekapitulasi.dart';
import 'package:Grademaster/Pages/signin/login.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:Grademaster/profile.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const Index());
}

class Index extends StatelessWidget {
  const Index({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/index': (context) => Index(),
        '/login': (context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Grade Master',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // List of pages for each tab
  final List<Widget> _pages = [
    HomePelajar(), // Beranda
    RekapitulasiPage(), // Highlights
    ProfilePage(), // Settings
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> checkLoginStatus() async {
    String? token = await storage.read(key: 'user_token');
    if (token == null) {
      // Jika token hilang, arahkan ke halaman login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _pages[_currentIndex], // Menampilkan halaman sesuai dengan indeks tab
      bottomNavigationBar: FlashyTabBar(
        backgroundColor: OwnColor.colors['BiruTua'],
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(
              Icons.home_filled,
              color: OwnColor.colors['Putih'],
            ),
            title: Text(
              'Beranda',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              Icons.book,
              color: OwnColor.colors['Putih'],
            ),
            title: Text(
              'Rekapitulasi',
              style: TextStyle(color: Colors.white),
            ),
          ),
          FlashyTabBarItem(
            icon: Icon(
              Icons.person,
              color: OwnColor.colors['Putih'],
            ),
            title: Text(
              'Profil',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
