import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RekapNilai extends StatefulWidget {
  const RekapNilai({super.key});

  @override
  _RekapNilaiState createState() => _RekapNilaiState();
}

class _RekapNilaiState extends State<RekapNilai> {
  List<dynamic> _rekapitulasiData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRekapitulasiData();
  }

  Future<void> _fetchRekapitulasiData() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/note_app/rekapitulasi/list_pengajar.php'),
      );

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
      _showErrorDialog('Terjadi kesalahan: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
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
                    image: AssetImage('ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Center(
                child: Text('Rekapitulasi',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // Call Navigator.pop() to go back to the previous screen
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rekapitulasiData.isEmpty
              ? const Center(child: Text('Tidak ada data rekapitulasi.'))
              : ListView.builder(
                  itemCount: _rekapitulasiData.length,
                  itemBuilder: (context, index) {
                    final rekap = _rekapitulasiData[index];
                    double gradePass = rekap['grade_pass'] != null
                        ? double.tryParse(rekap['grade_pass'].toString()) ?? 0
                        : 0;
                    double totalNilai =
                        double.tryParse(rekap['total_nilai'].toString()) ?? 0;

                    // Tentukan warna berdasarkan perbandingan grade_pass dan total_nilai
                    Color textColor =
                        gradePass >= totalNilai ? Colors.red : Colors.green;

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(rekap['semester'].toString()),
                      ),
                      title: Text(
                        '${rekap['nama_lengkap']}',
                        style: TextStyle(
                            color:
                                textColor), // Nama lengkap di atas nama matkul
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Nilai: ${rekap['total_nilai']}'),
                          Text('Waktu Selesai: ${rekap['waktu_selesai']}'),
                          Text(
                            'Grade Pass: ${rekap['grade_pass']}',
                            style: TextStyle(
                                color: textColor, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${rekap['nama_matkul']}',
                            style: TextStyle(
                                color:
                                    textColor), // Nama mata kuliah di bawah nama lengkap
                          ),
                          Text(
                            '${rekap['nama_assesmen']}',
                            style: TextStyle(
                                color:
                                    textColor), // Nama mata kuliah di bawah nama lengkap
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
