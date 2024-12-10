import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  String? _selectedClass; // Untuk menyimpan pilihan kelas
  List<String> _classList = []; // Daftar kelas

  @override
  void initState() {
    super.initState();

    print("Received arguments: ${widget.arguments}");

    _namaSesiController =
        TextEditingController(text: widget.arguments['nama_assesmen']);
    _keteranganController =
        TextEditingController(text: widget.arguments['ket_assesmen']);
    _tanggalController =
        TextEditingController(text: widget.arguments['tanggal']);
    _gradePassController =
        TextEditingController(text: widget.arguments['grade_pass']);
    _selectedClass = widget.arguments['nama_kelas']; // Nilai awal kelas

    _fetchClassList(); // Ambil daftar kelas
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

  Future<void> _updateData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final updatedData = {
      'id': widget.arguments['id'],
      'nama_sesi': _namaSesiController.text,
      'keterangan': _keteranganController.text,
      'tanggal': _tanggalController.text,
      'grade_pass': _gradePassController.text,
      'nama_kelas': _selectedClass,
    };

    if (updatedData['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: ID is null')),
      );
      return;
    }

    try {
      print("Sending Data: $updatedData");
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
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Update failed: ${jsonResponse['message']}'),
            ),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Assessment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      });
                    }
                  : null, // Dropdown tidak aktif jika tidak ada data
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
              readOnly: true,
              onTap: _pickDate,
              validator: (value) =>
                  value!.isEmpty ? 'Tanggal tidak boleh kosong' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _gradePassController,
              decoration: const InputDecoration(labelText: 'Grade Pass'),
              validator: (value) =>
                  value!.isEmpty ? 'Grade pass tidak boleh kosong' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateData,
              child: const Text('Save Changes'),
            ),
          ]),
        ),
      ),
    );
  }
}
