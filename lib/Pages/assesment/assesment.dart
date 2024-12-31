import 'package:Grademaster/Pages/assesment/addsoal.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format waktu
import 'package:http/http.dart' as http;
import 'dart:convert';

class AssesmentPage extends StatefulWidget {
  const AssesmentPage({super.key});

  @override
  _JadwalUjianPageState createState() => _JadwalUjianPageState();
}

class _JadwalUjianPageState extends State<AssesmentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _waktuMulaiController = TextEditingController();
  final TextEditingController _waktuSelesaiController = TextEditingController();
  final TextEditingController _namaAssesmenController = TextEditingController();
  final TextEditingController _ketAssesmenController = TextEditingController();
  final TextEditingController _gradePassController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _waktuMulai = TimeOfDay.now();
  TimeOfDay _waktuSelesai = TimeOfDay.now();

  List<dynamic> _mataKuliah = [];
  List<dynamic> _kelas = [];
  List<dynamic> allKelas = [];
  String? _selectedMatkul;
  String? _selectedKelas;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchAllKelas();
  }

  Future<void> _fetchAllKelas() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1/note_app/sesi/get.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            allKelas = data['kelas'];
            _kelas = allKelas; // Default semua kelas
          });
        }
      }
    } catch (e) {
      _showErrorMessage('Error fetching kelas: $e');
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1/note_app/sesi/get.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            _mataKuliah = data['mata_kuliah'];
            _kelas = data['kelas'];
          });
        } else {
          _showErrorMessage('Failed to load data');
        }
      } else {
        _showErrorMessage('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorMessage('Error fetching data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = "${_selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final formattedTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm')
        .format(formattedTime); // HH:mm untuk format 24 jam
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _waktuMulai : _waktuSelesai,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _waktuMulai = picked;
          _waktuMulaiController.text = _formatTime(picked); // Format ke 24 jam
        } else {
          // Ensure end time is after start time
          if (picked.hour < _waktuMulai.hour ||
              (picked.hour == _waktuMulai.hour &&
                  picked.minute <= _waktuMulai.minute)) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Waktu Selesai harus setelah Waktu Mulai')));
            return;
          }
          _waktuSelesai = picked;
          _waktuSelesaiController.text =
              _formatTime(picked); // Format ke 24 jam
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedKelas == null || _selectedMatkul == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please select Mata Kuliah and Kelas')));
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        final requestBody = {
          'id_kelas': _selectedKelas!,
          'tanggal': _tanggalController.text,
          'waktu_mulai': _waktuMulaiController.text,
          'waktu_selesai': _waktuSelesaiController.text,
          'id_matkul': _selectedMatkul!,
          'nama_assesmen': _namaAssesmenController.text,
          'ket_assesmen': _ketAssesmenController.text,
          'grade_pass': _gradePassController.text,
        };

        print(
            'Data yang dikirimkan: $requestBody'); // Menampilkan data yang dikirimkan

        final response = await http.post(
          Uri.parse('http://127.0.0.1/note_app/sesi/create.php'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: requestBody,
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        final data = json.decode(response.body);

        if (response.statusCode == 200 && data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data successfully submitted')));

          // Navigate to AddSoal after successful submission
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const AddSoal()));
        } else {
          // Show error message from server response
          String errorMessage = data['message'] ?? 'Submission failed';
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error submitting data: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Input Jadwal Ujian')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              if (_isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Submitting your data... please wait...'),
              ],
              if (!_isLoading) ...[
                DropdownButtonFormField<String>(
                  value: _selectedMatkul,
                  decoration: InputDecoration(
                    labelText: 'Matakuliah',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: Color(0xFF214C7A)),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedMatkul = newValue;

                      // Filter data `kelas` berdasarkan `id_prodi`
                      final selectedMatkul = _mataKuliah.firstWhere(
                        (matkul) => matkul['id_matkul'] == newValue,
                        orElse: () => null,
                      );

                      if (selectedMatkul != null) {
                        _kelas = allKelas
                            .where((kelas) =>
                                kelas['id_prodi'] == selectedMatkul['id_prodi'])
                            .toList();
                      } else {
                        _kelas = [];
                      }

                      // Reset pilihan kelas
                      _selectedKelas = null;
                    });
                  },
                  items: _mataKuliah.map<DropdownMenuItem<String>>((matkul) {
                    return DropdownMenuItem<String>(
                      value: matkul['id_matkul'].toString(),
                      child: Text(matkul['nama_matkul']),
                    );
                  }).toList(),
                  validator: (value) =>
                      value == null ? 'ID Mata Kuliah is required' : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedKelas,
                  decoration: InputDecoration(
                    labelText: 'Kelas',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    border: authOutlineInputBorder,
                    enabledBorder: authOutlineInputBorder.copyWith(
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: authOutlineInputBorder.copyWith(
                      borderSide: const BorderSide(color: Color(0xFF214C7A)),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedKelas = newValue;
                    });
                  },
                  items: _kelas.isEmpty
                      ? null
                      : _kelas.map<DropdownMenuItem<String>>((kelas) {
                          return DropdownMenuItem<String>(
                            value: kelas['id_kelas'].toString(),
                            child: Text(kelas['nama_kelas']),
                          );
                        }).toList(),
                  validator: (value) =>
                      value == null ? 'Kelas is required' : null,
                  disabledHint: const Text('Tidak ada Kelas'),
                ),
                ..._buildInputFields(),
                const SizedBox(height: 20),
                SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: OwnColor.colors['Hijau'],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () async {
                          print('Submit button pressed');
                          await _submitForm();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(color: OwnColor.colors['Putih']),
                        ),
                      ),
                    )),
                const SizedBox(
                  height: 10,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  var authOutlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
        color: OwnColor.colors['Red'] ??
            Colors.black), // Menggunakan warna hitam sebagai default
    borderRadius: const BorderRadius.all(Radius.circular(15)),
  );

  List<Widget> _buildInputFields() {
    return [
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _tanggalController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Tanggal',
          // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context),
        validator: (value) => value!.isEmpty ? 'Tanggal is required' : null,
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _waktuMulaiController,
        decoration: InputDecoration(
          labelText: 'Waktu Mulai',
          // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
        readOnly: true,
        onTap: () => _selectTime(context, true),
        validator: (value) => value!.isEmpty ? 'Waktu Mulai is required' : null,
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _waktuSelesaiController,
        decoration: InputDecoration(
          labelText: 'Waktu Selesai',
          // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
        readOnly: true,
        onTap: () => _selectTime(context, false),
        validator: (value) =>
            value!.isEmpty ? 'Waktu Selesai is required' : null,
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _namaAssesmenController,
        decoration: InputDecoration(
          labelText: 'Nama Assesmen',
          // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Nama Assesmen is required' : null,
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _ketAssesmenController,
        decoration: InputDecoration(
          labelText: 'Keterangan Assesmen',
          // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Keterangan Assesmen is required' : null,
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: _gradePassController,
        decoration: InputDecoration(
          labelText: 'Grade Pass',
          hintText: '75',
          // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder.copyWith(
              borderSide: const BorderSide(color: Colors.grey)),
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? 'Grade Pass is required' : null,
      ),
    ];
  }
}
