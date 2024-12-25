import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RekapNilai extends StatefulWidget {
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
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rekapitulasi'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _rekapitulasiData.isEmpty
              ? Center(child: Text('Tidak ada data rekapitulasi.'))
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
