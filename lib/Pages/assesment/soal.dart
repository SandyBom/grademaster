import 'package:flutter/material.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';
// TODO: add flutter_svg to pubspec.yaml

class SoalAssesmen extends StatelessWidget {
  static const nameRoute = '/soalassesmen';

  const SoalAssesmen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 90),
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
                child: Text('Beranda',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
            ],
          ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(child: Text('Soal 1')),
                Container(
                  child: Text('Duration 17:23'),
                )
              ],
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                  color: OwnColor.colors['AbuAbu'],
                  image: DecorationImage(
                      image: AssetImage('rb_2150923186.png'),
                      fit: BoxFit.fitHeight)),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Lorem ipsum kqwejkqwjeq kaowkaodma sdjasd akjsdasbd'),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                MyForm(),
                MyForm(),
                MyForm(),
                MyForm(),
                MyForm(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
