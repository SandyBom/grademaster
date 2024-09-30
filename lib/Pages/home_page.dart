import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppBar dengan Border Radius',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(169), // Tinggi AppBar
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(169)),
          child: Container(
            color: Colors.green, // Warna AppBar
            child: Center(
              child: Text(
                'Beranda',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Center(child: Text('Konten Utama')),
    );
  }
}
