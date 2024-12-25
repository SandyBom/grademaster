import 'package:Grademaster/Pages/index_pengajar.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class EditAsessment extends StatefulWidget {
  const EditAsessment({super.key, required this.arguments});

  final Map<String, dynamic> arguments;

  @override
  State<EditAsessment> createState() => _EditAsessmentState();
}

class _EditAsessmentState extends State<EditAsessment> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaSesiController;
  late TextEditingController _keteranganController;
  late TextEditingController _tanggalController;
  late TextEditingController _gradePassController;
  late TextEditingController _waktuMulaiController;
  late TextEditingController _waktuSelesaiController;
  String? _selectedClass;
  List<String> _classList = [];

  @override
  void initState() {
    super.initState();

    _namaSesiController =
        TextEditingController(text: widget.arguments['nama_assesmen'] ?? '');
    _keteranganController =
        TextEditingController(text: widget.arguments['ket_assesmen'] ?? '');
    _tanggalController =
        TextEditingController(text: widget.arguments['tanggal'] ?? '');
    _gradePassController =
        TextEditingController(text: widget.arguments['grade_pass'] ?? '');
    _waktuMulaiController =
        TextEditingController(text: widget.arguments['waktu_mulai'] ?? '');
    _waktuSelesaiController =
        TextEditingController(text: widget.arguments['waktu_selesai'] ?? '');
    _selectedClass = widget.arguments['nama_kelas'];

    _fetchClassList();
  }

  Future<void> _fetchClassList() async {
    try {
      final response =
          await http.get(Uri.parse("http://127.0.0.1/note_app/kelas/list.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['nama_kelas'] != null) {
          setState(() {
            _classList = List<String>.from(data['nama_kelas']);
          });
        } else {
          throw Exception('Data classes tidak ditemukan atau kosong');
        }
      } else {
        throw Exception('Failed to load class list: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching class list: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading class list: $e')),
      );
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(formattedTime);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    // Ambil waktu dari controller jika sudah ada
    TimeOfDay currentTime = isStartTime
        ? _parseTime(_waktuMulaiController.text)
        : _parseTime(_waktuSelesaiController.text);

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTime, // Waktu awal berdasarkan inputan sebelumnya
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _waktuMulaiController.text = _formatTime(picked); // Setel waktu mulai
        } else {
          // Pastikan waktu selesai setelah waktu mulai
          if (picked.hour < _parseTime(_waktuMulaiController.text).hour ||
              (picked.hour == _parseTime(_waktuMulaiController.text).hour &&
                  picked.minute <=
                      _parseTime(_waktuMulaiController.text).minute)) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Waktu Selesai harus setelah Waktu Mulai')));
            return;
          }
          _waktuSelesaiController.text =
              _formatTime(picked); // Setel waktu selesai
        }
      });
    }
  }

  TimeOfDay _parseTime(String time) {
    final timeParts = time.split(':');
    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  Future<void> _updateData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedClass == null || _selectedClass!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kelas sebelum menyimpan.')),
      );
      return;
    }

    final updatedData = {
      'id': widget.arguments['id'],
      'nama_sesi': _namaSesiController.text.trim(),
      'keterangan': _keteranganController.text.trim(),
      'tanggal': _tanggalController.text.trim(),
      'grade_pass': _gradePassController.text.trim(),
      'nama_kelas': _selectedClass,
    };

    print("Sending Data: $updatedData");

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1/note_app/sesi/update.php"),
        body: jsonEncode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data updated successfully!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => IndexPengajar()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Update failed: ${jsonResponse['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
      print("Tanggal Setelah Dipilih: ${_tanggalController.text}");
    } else {
      print("Pemilihan tanggal dibatalkan.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
                  image: DecorationImage(
                    image: AssetImage('ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Text('Edit Assesmen',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaSesiController,
                decoration: const InputDecoration(labelText: 'Nama Sesi'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama sesi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                maxLines: null,
                validator: (value) =>
                    value!.isEmpty ? 'Keterangan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value:
                    _classList.contains(_selectedClass) ? _selectedClass : null,
                items: _classList.isNotEmpty
                    ? _classList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                    : [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Tidak ada kelas tersedia'),
                        ),
                      ],
                onChanged: _classList.isNotEmpty
                    ? (value) {
                        setState(() {
                          _selectedClass = value;
                          print("Selected class updated: $_selectedClass");
                        });
                      }
                    : null,
                decoration: const InputDecoration(labelText: 'Pilih Kelas'),
                validator: (value) =>
                    value == null ? 'Pilih kelas yang valid' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _tanggalController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: false,
                onTap: _pickDate,
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              // TextFormField(
              //   controller: _waktuMulaiController,
              //   decoration: InputDecoration(
              //     labelText: 'Waktu Mulai',
              //   ),
              //   readOnly: true, // Agar hanya bisa memilih waktu
              //   onTap: () => _selectTime(
              //       context, true), // Fungsi untuk memilih waktu mulai
              //   validator: (value) =>
              //       value!.isEmpty ? 'Waktu Mulai harus diisi' : null,
              // ),
              // TextFormField(
              //   controller: _waktuSelesaiController,
              //   decoration: InputDecoration(
              //     labelText: 'Waktu Selesai',
              //   ),
              //   readOnly: true, // Agar hanya bisa memilih waktu
              //   onTap: () => _selectTime(
              //       context, false), // Fungsi untuk memilih waktu selesai
              //   validator: (value) =>
              //       value!.isEmpty ? 'Waktu Selesai harus diisi' : null,
              // ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _gradePassController,
                decoration: const InputDecoration(labelText: 'Grade Pass'),
                validator: (value) =>
                    value!.isEmpty ? 'Grade pass tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: _updateData,
                  child: Text(
                    'Simpan Perubahan',
                    style: TextStyle(color: OwnColor.colors['Putih']),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        OwnColor.colors['BiruTua'], // Warna tombol hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Membuat tombol dengan sudut tumpul
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
