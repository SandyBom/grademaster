import 'dart:convert';
import 'package:Grademaster/Pages/signin/login.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String? role,
      namaPengguna,
      namaLengkap,
      email,
      kataSandi,
      kelamin,
      nisNip,
      tanggalLahir,
      noTelp,
      alamat,
      semester;

  TextEditingController tanggalLahirController = TextEditingController();

  Future<void> registerUser() async {
    final url = Uri.parse('http://127.0.0.1/note_app/signin/register.php');

    final body = {
      'role': role,
      'nama_pengguna': namaPengguna,
      'nama_lengkap': namaLengkap,
      'email': email,
      'kata_sandi': kataSandi,
      'tanggal_lahir': tanggalLahir,
      'nis_nip': nisNip,
      'kelamin': kelamin,
      'no_telp': noTelp,
      'alamat': alamat,
      // Only include semester if the role is 'pelajar'
      if (role == "pelajar") 'semester': semester,
    };

    try {
      print('Mengirim data ke server: $body');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      print('Status kode respons: ${response.statusCode}');
      print('Body respons: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          // Menampilkan Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Anda berhasil terdaftar!')));

          // Navigasi ke halaman LoginPage setelah 2 detik
          await Future.delayed(Duration(seconds: 2));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          print('Registrasi gagal: ${responseData['message']}');
          print('Debug info: ${responseData['debug']}');
        }
      } else {
        print('Gagal menghubungi server. Status kode: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
        tanggalLahir = tanggalLahirController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrasi')),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: role,
                items: ['pelajar', 'pengajar']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => role = val),
                decoration: InputDecoration(
                  labelText: 'Role',
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
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Pengguna',
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
                onChanged: (val) => namaPengguna = val,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
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
                onChanged: (val) => namaLengkap = val,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
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
                onChanged: (val) => email = val,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
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
                obscureText: true,
                onChanged: (val) => kataSandi = val,
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: tanggalLahirController,
                    decoration: InputDecoration(
                      labelText: 'Tanggal Lahir',
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
                    onChanged: (val) => tanggalLahir = val,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'NIS/NIP',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        border: authOutlineInputBorder,
                        enabledBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: authOutlineInputBorder.copyWith(
                          borderSide:
                              const BorderSide(color: Color(0xFF214C7A)),
                        ),
                      ),
                      onChanged: (val) => nisNip = val,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin (L/P)',
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        border: authOutlineInputBorder,
                        enabledBorder: authOutlineInputBorder.copyWith(
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: authOutlineInputBorder.copyWith(
                          borderSide:
                              const BorderSide(color: Color(0xFF214C7A)),
                        ),
                      ),
                      onChanged: (val) => kelamin = val,
                    ),
                  )
                ],
              ),
              if (role == 'pelajar')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Semester',
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
                  onChanged: (val) => semester = val,
                ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'No Telepon',
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
                onChanged: (val) => noTelp = val,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Alamat',
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
                onChanged: (val) => alamat = val,
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: registerUser,
                  child: Text('Register',
                      style: TextStyle(
                        color: OwnColor.colors['Putih'],
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        OwnColor.colors['Hijau'], // Warna tombol hijau
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15), // Membuat tombol dengan sudut tumpul
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
