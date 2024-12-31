import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RekapitulasiPage extends StatefulWidget {
  const RekapitulasiPage({super.key});

  @override
  _RekapitulasiPageState createState() => _RekapitulasiPageState();
}

class _RekapitulasiPageState extends State<RekapitulasiPage> {
  List<dynamic> _rekapitulasiData = [];
  bool _isLoading = true;

  final storage = const FlutterSecureStorage(); // Untuk menyimpan token
  String? token; // Untuk menyimpan token yang diambil
  String? idPelajar; // Store idPelajar here

  @override
  void initState() {
    super.initState();
    _fetchRekapitulasiData();
    _initializePage();
  }

  Future<void> _initializePage() async {
    await _loadData(); // Pastikan data dimuat terlebih dahulu
    _fetchRekapitulasiData(); // Panggil setelah data berhasil dimuat
  }

  Future<void> _loadData() async {
    try {
      final storedToken = await storage.read(key: 'user_token');
      final storedId = await storage.read(key: 'user_id');

      setState(() {
        token = storedToken;
        idPelajar = storedId;
      });

      print('Token: $token');
      print('ID Pelajar: $idPelajar');
    } catch (e) {
      print('Error mengambil data dari storage: $e');
    }
  }

  Future<void> _fetchRekapitulasiData() async {
    if (idPelajar == null) {
      print('ID Pelajar tidak ditemukan.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'http://127.0.0.1/note_app/rekapitulasi/list.php?id_pelajar=$idPelajar'),
      );

      print(
          'Fetching URL: http://127.0.0.1/note_app/rekapitulasi/list.php?id_pelajar=$idPelajar');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            _rekapitulasiData = data['data'];
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
      _showErrorDialog('Belum ada Assesmen yang kamu kerjakan');
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
      appBar: AppBar(
        title: const Text('Rekapitulasi'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rekapitulasiData.isEmpty
              ? const Center(child: Text('Tidak ada data rekapitulasi.'))
              : ListView.builder(
                  itemCount: _rekapitulasiData.length,
                  itemBuilder: (context, index) {
                    final rekap = _rekapitulasiData[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(rekap[''].toString()),
                      ),
                      title: Text('${rekap['nama_matkul']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Nilai: ${rekap['total_nilai']}'),
                          Text('Waktu Selesai: ${rekap['waktu_selesai']}'),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
