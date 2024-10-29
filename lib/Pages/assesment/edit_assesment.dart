import 'package:flutter/material.dart';

class EditAssesment extends StatelessWidget {
  const EditAssesment({super.key});
  static const nameRoute = '/editassesmen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 90),
          child: SafeArea(
              child: Stack(
            children: [
              Container(
                child: Positioned(
                  top: 30,
                  left: 20,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
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
                child: Text('Beranda',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
