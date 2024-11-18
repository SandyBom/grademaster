import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  TextEditingController namaPengguna = TextEditingController();
  TextEditingController namaPanjang = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController noTelp = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController tanggalLahir = TextEditingController();
  TextEditingController jenisKelamin = TextEditingController();

  Future<void> insertrecord() async {
    if (namaPanjang.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty) {
      print("Please fill all fields");
      return; // Exit if fields are empty
    }

    String uri = "http://192.168.56.1/grademaster/insert_record.php";
    var data = {
      "namaPanjang": namaPanjang.text,
      "email": email.text,
      "password": password.text,
    };

    try {
      var response = await http.post(
        Uri.parse(uri),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (jsonResponse["succes"] == "true") {
          print("Record Inserted");
        } else {
          print("Some Issue: ${jsonResponse["message"]}");
        }
      } else {
        print("Failed to insert record: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    namaPengguna.dispose();
    namaPanjang.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 50),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Stack(
                children: [
                  Container(
                    child: Positioned(
                      top: 30,
                      left: 20,
                      child: FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                  )
                ],
              ),
            )),
        body: ListView(padding: EdgeInsets.fromLTRB(20, 0, 20, 0), children: [
          FormRegister(
            namaPanjang: namaPanjang,
            namaPengguna: namaPengguna,
            email: email,
            password: password,
          ),
        ]),
      ),
    );
  }
}

class FormRegister extends StatelessWidget {
  final TextEditingController namaPanjang;
  final TextEditingController namaPengguna;
  final TextEditingController email;
  final TextEditingController password;

  FormRegister({
    required this.namaPanjang,
    required this.namaPengguna,
    required this.email,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image(
              image: AssetImage('rb_2150923186.png'),
              fit: BoxFit.contain,
            )),
        Container(
            margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
            height: 55,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: TextFormField(
                controller: namaPanjang,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  labelText: "Username",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF214C7A))),
                ))),
        Container(
            margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
            height: 55,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF214C7A))),
                ))),
        Container(
            margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
            height: 55,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: TextFormField(
                controller: namaPengguna,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Email",
                  labelText: "Email",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF214C7A))),
                ))),
        Container(
            margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
            height: 55,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Rewrite Password",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF214C7A))),
                ))),
        ElevatedButton(
          onPressed: () {
            // Call the insert record function
            // (This will require the parent state to be updated)
          },
          child: Text('Register'),
        ),
      ],
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF214C7A)),
  borderRadius: BorderRadius.all(Radius.circular(15)),
);
