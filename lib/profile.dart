import 'dart:convert';
import 'package:Grademaster/Pages/signin/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  String? token;
  String? userId;
  String? role;
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData().then((_) => _fetchUserData());
  }

  Future<void> logout(BuildContext context) async {
    // Menghapus token dan role dari storage
    await storage.delete(key: 'user_token');
    await storage.delete(key: 'user_id');
    await storage.delete(key: 'user_role');

    // Arahkan pengguna ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _loadData() async {
    try {
      // Membaca token dan data pengguna dari storage
      token = await storage.read(key: 'user_token');
      userId = await storage.read(key: 'user_id');
      role = await storage.read(key: 'user_role');

      setState(() {});
      print('Token: $token');
      print('User ID: $userId');
      print('Role: $role');
    } catch (e) {
      print('Error membaca data dari storage: $e');
    }
  }

  Future<void> _fetchUserData() async {
    if (userId == null || role == null) {
      print('ID pengguna atau role tidak ditemukan.');
      return;
    }

    try {
      final url = role == 'pelajar'
          ? 'http://127.0.0.1/note_app/pelajar/list.php?id_pelajar=$userId'
          : 'http://127.0.0.1/note_app/pengajar/list.php?id_pengajar=$userId';

      final response = await http.get(Uri.parse(url));

      print('Fetching URL: $url');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            userData = data['data'][0];
            _isLoading = false;
          });
        } else {
          _showErrorDialog(data['message']);
        }
      } else {
        _showErrorDialog(
            'Gagal mengambil data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Gagal mengambil data pengguna');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pemberitahuan'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 40),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
                  image: DecorationImage(
                    image: AssetImage('assets/ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Center(
                child: Text('Profile',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Foto Profil
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 60, // Ganti dengan data gambar pengguna
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              onPressed: () {
                                // Fitur ubah foto
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Nama Lengkap
                  ListTile(
                    title: const Text(
                      'Nama Lengkap',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userData?['nama_lengkap'] ?? 'Tidak tersedia',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  // Email
                  ListTile(
                    title: const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userData?['email'] ?? 'Tidak tersedia',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  // Nama Pengguna
                  ListTile(
                    title: const Text(
                      'Nama Pengguna',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userData?['nama_pengguna'] ?? 'Tidak tersedia',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Divider(),
                  // Tombol Logout
                  Center(
                    child: ElevatedButton(
                      onPressed: () => logout(context),
                      style: ElevatedButton.styleFrom(),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
