import 'dart:convert';
import 'package:Grademaster/Pages/index.dart';
import 'package:Grademaster/Pages/index_pengajar.dart';
import 'package:Grademaster/Pages/signin/register.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? role, email, kataSandi;
  bool isLoading = false;
  final storage = FlutterSecureStorage(); // Untuk menyimpan token

  // Fungsi login yang akan menghubungi API
  Future<void> loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Mulai loading
      });

      final url = Uri.parse('http://127.0.0.1/note_app/signin/login.php');

      final body = {
        'role': role!,
        'email': email!,
        'kata_sandi': kataSandi!,
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body),
        );

        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login berhasil!')),
          );

          // Menyimpan token dan mendekode id_user
          // Menyimpan token dan mendekode id_user
          if (responseData.containsKey('token')) {
            String token = responseData['token'];
            await storage.write(key: 'user_token', value: token);

            // Simpan role pengguna ke dalam storage
            await storage.write(key: 'user_role', value: role); // Tambahkan ini

            // Dekode token untuk mendapatkan id_user
            final jwt = JWT.verify(
                token,
                SecretKey(
                    'your-secret-key')); // Ganti dengan secret key server Anda
            String userId =
                jwt.payload['id'].toString(); // Ambil id dari payload
            await storage.write(key: 'user_id', value: userId);

            // Pastikan hanya masuk ke halaman yang sesuai setelah login
            if (role == 'pelajar') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (BuildContext context) => Index()),
              );
            } else if (role == 'pengajar') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => IndexPengajar()),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Token tidak ditemukan, login gagal.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan, coba lagi.')),
        );
      } finally {
        setState(() {
          isLoading = false; // Selesai loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                'rb_2150923186.png',
                width: 250,
                height: 250,
              ),
              // Dropdown untuk memilih Role
              DropdownButtonFormField<String>(
                value: role,
                items: ['pelajar', 'pengajar']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(toTitleCase(role)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    role = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih role' : null,
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
                onChanged: (value) {
                  email = value;
                },
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
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
                onChanged: (value) {
                  kataSandi = value;
                },
                validator: (value) =>
                    value!.isEmpty ? 'Kata sandi tidak boleh kosong' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                        width: double
                            .infinity, // Membuat tombol mengambil lebar penuh
                        height: 45, // Tinggi tombol
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: ElevatedButton(
                            onPressed: isLoading ? null : loginUser,
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                        color: OwnColor.colors['Putih']),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OwnColor
                                  .colors['BiruTua'], // Warna tombol hijau
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Membuat tombol dengan sudut tumpul
                              ),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                        width: double
                            .infinity, // Membuat tombol mengambil lebar penuh
                        height: 45, // Tinggi tombol
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()),
                              );
                            },
                            child: isLoading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Register',
                                    style: TextStyle(
                                        color: OwnColor.colors['Putih']),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: OwnColor
                                  .colors['Hijau'], // Warna tombol hijau
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15), // Membuat tombol dengan sudut tumpul
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}
