import 'package:flutter/material.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';

class DescriptionPage extends StatelessWidget {
  static const nameRoute = '/descriptionpage';

  const DescriptionPage({super.key});
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
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.elliptical(40, 40)),
                    image: DecorationImage(
                      image: AssetImage('ab.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Center(
                  child: Text('Fisika Dasar',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ))),
        body: ListView(
          children: [
            BigBox(),
            Description(),
            BigButtonG(
              label: 'Kerjakan Assesmen',
            ),
            Answer(jawaban: 'Lorem Ipsum')
          ],
        ));
  }
}

class BigBox extends StatelessWidget {
  const BigBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: OwnColor.colors['Biru'],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: DataTable(columns: [
              DataColumn(
                  label: Text(
                'Lorem Ipsum Color de Muatamu',
                style: TextStyle(
                  color: OwnColor.colors['Putih'],
                  fontWeight: FontWeight.w800,
                  fontSize: MediaQuery.of(context).size.width * 0.025,
                ),
              )),
              DataColumn(label: Text('')),
            ], rows: [
              DataRow(cells: [
                DataCell(Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: OwnColor.colors['Putih'],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Jumlah Soal',
                      style: TextStyle(color: OwnColor.colors['Putih']),
                    )
                  ],
                )),
                DataCell(Text(
                  ': 25',
                  style: TextStyle(color: OwnColor.colors['Putih']),
                )),
              ]),
              DataRow(cells: [
                DataCell(Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      color: OwnColor.colors['Putih'],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Druasi Pengerjaan',
                      style: TextStyle(color: OwnColor.colors['Putih']),
                    )
                  ],
                )),
                DataCell(Text(
                  ': 25 menit',
                  style: TextStyle(color: OwnColor.colors['Putih']),
                )),
              ]),
              DataRow(cells: [
                DataCell(Row(
                  children: [
                    Icon(
                      Icons.timer_off_outlined,
                      color: OwnColor.colors['Putih'],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Tengat Waktu',
                        style: TextStyle(
                          color: OwnColor.colors['Putih'],
                        ))
                  ],
                )),
                DataCell(Text(
                  ': 17 September 2024',
                  style: TextStyle(color: OwnColor.colors['Putih']),
                )),
              ]),
            ])));
  }
}

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Syarat dan Ketentuan Assesmen',
                ),
                Text(
                  'Lorem impsum de arif de cotole',
                )
              ],
            )));
  }
}
