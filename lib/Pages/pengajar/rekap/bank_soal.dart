import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BankSoalPage extends StatefulWidget {
  const BankSoalPage({super.key});

  @override
  _BankSoalPageState createState() => _BankSoalPageState();
}

class _BankSoalPageState extends State<BankSoalPage> {
  List<dynamic> _assessments = [];

  @override
  void initState() {
    super.initState();
    fetchAssessments();
  }

  Future<void> fetchAssessments() async {
    // Replace with your API endpoint to fetch assessment names
    const url = 'http://127.0.0.1/note_app/sesi/list_pengajar.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _assessments = data['data'];
        });
      } else {
        throw Exception('Failed to load assessments');
      }
    } catch (e) {
      print('Error fetching assessments: $e');
    }
  }

  Future<void> fetchQuestions(String idAssesmen) async {
    final url =
        'http://127.0.0.1/note_app/soal_ujian/banksoal.php?id_assesmen=$idAssesmen';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionsPage(data: data['data']),
          ),
        );
      } else {
        throw Exception('Failed to load questions');
      }
    } catch (e) {
      print('Error fetching questions: $e');
    }
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
                child: Text('Bank Soal',
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
      body: _assessments.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _assessments.length,
              itemBuilder: (context, index) {
                final assessment = _assessments[index];
                return ListTile(
                  title: Text(assessment['nama_assesmen']),
                  onTap: () => fetchQuestions(assessment['id_assesmen']),
                );
              },
            ),
    );
  }
}

class QuestionsPage extends StatelessWidget {
  final List<dynamic> data;

  const QuestionsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final question = data[index];
          return Card(
            child: ListTile(
              title: Text(question['soal']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...question['jawaban'].map<Widget>((answer) {
                    return Text(
                        "- ${answer['keterangan_pilihan']} (${answer['benar_salah'] == '1' ? 'Correct' : 'Wrong'})");
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
