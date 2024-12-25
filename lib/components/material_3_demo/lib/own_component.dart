import 'package:flutter/material.dart';
import 'package:Grademaster/Pages/assesment/soal.dart';

class BigButtonB extends StatelessWidget {
  const BigButtonB({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  static final actions = [ElevatedButton(onPressed: () {}, child: const Text(''))];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['Biru'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Text(
              label,
              style: TextStyle(color: OwnColor.colors['Putih']),
            ),
          )),
    );
  }
}

class BigButtonG extends StatelessWidget {
  // Konstruktor dengan parameter label dan onPressed
  const BigButtonG(
      {super.key,
      required this.label,
      this.onPressed,
      required this.matkul,
      required this.id,
      required this.waktu_m,
      required this.jadwal,
      required this.waktu_s});

  // Parameter untuk label dan onPressed yang akan diteruskan ke ElevatedButton
  final String id;
  final String waktu_m;
  final String waktu_s;
  final String jadwal;
  final String label;
  final VoidCallback? onPressed;
  final String matkul;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity, // Membuat tombol mengambil lebar penuh
        height: 45, // Tinggi tombol
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Menampilkan dialog alert
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content:
                          const Text('Apakah Anda yakin ingin melanjutkan?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Menutup dialog
                          },
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SoalAssesmen(
                                  idmatkul: matkul,
                                  jadwal: jadwal,
                                  id: id,
                                  waktuMulai: waktu_m,
                                  waktuSelesai: waktu_s,
                                ),
                              ),
                            ); // Menutup dialog
                            // Tambahkan aksi Anda di sini
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Melanjutkan proses')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: OwnColor.colors['Hijau'],
                          ),
                          child: const Text('Lanjut'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['Hijau'], // Warna tombol hijau
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15), // Membuat tombol dengan sudut tumpul
                ),
              ),
              child: const Text(
                'Kerjakan Assesmen',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )));
  }
}

class MyCheckbox extends StatefulWidget {
  const MyCheckbox({super.key});

  @override
  _MyCheckboxState createState() => _MyCheckboxState();
}

class _MyCheckboxState extends State<MyCheckbox> {
  bool? _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Checkbox(
        value: _isChecked,
        onChanged: (bool? newValue) {
          setState(() {
            _isChecked = newValue;
          });
        },
        activeColor: Colors.green,
        checkColor: Colors.white,
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  const MyForm({super.key, required this.valueAnswer});
  final String valueAnswer;

  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _controller = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                obscureText: false,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: widget.valueAnswer,
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
              ),
            ),
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class Answer extends StatelessWidget {
  final String jawaban;

  const Answer({
    Key,
    key,
    required this.jawaban,
  }) : super(key: key);
  @override
  Widget build(Object context) {
    return Container(
      height: 45,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                  width: BorderSide.strokeAlignOutside, color: Colors.grey))),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          const MyCheckbox(),
          const SizedBox(
            width: 10,
          ),
          Text(jawaban)
        ],
      ),
    );
  }
}

class HistorySoal extends StatelessWidget {
  const HistorySoal({super.key, required this.soal});
  final String soal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      width: double.infinity,
      height: 45,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(
              width: BorderSide.strokeAlignOutside, color: Colors.grey),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            soal,
            maxLines: null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Row(
              children: [
                FloatingActionButton.extended(
                  onPressed: () {},
                  elevation: 0,
                  label: const Row(
                    children: [Text('Edit'), Icon(Icons.edit)],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  onPressed: () {},
                  elevation: 0,
                  label: const Row(
                    children: [Text('Hapus'), Icon(Icons.delete)],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OwnForm extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obsecureText;
  final String hintText;
  final String labelText;

  const OwnForm({
    super.key,
    this.controller,
    this.validator,
    required this.obsecureText,
    required this.hintText,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        maxLines: null,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: 55,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['Hijau'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text('Next')));
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: 55,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['AbuAbu'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text('Previous')));
  }
}

class FinalButton extends StatelessWidget {
  const FinalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: 55,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['BiruTua'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text('Final Attempt')));
  }
}

BoxShadow customBoxShadow({
  Color color = Colors.black,
  double opacity = 0.5,
  double blurRadius = 10.0,
  double spreadRadius = 1.0,
  Offset offset = const Offset(0, 4),
}) {
  return BoxShadow(
    color: color.withOpacity(opacity),
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
    offset: offset,
  );
}

class OwnColor {
  static final Map<String, Color> colors = {
    'Biru': const Color(0xff64A8F0),
    'BiruMuda': const Color(0xffF2F5FF),
    'Hijau': const Color(0xff67C569),
    'BiruTua': const Color(0xFF4A3298),
    'AbuAbu': const Color(0xff908F8F),
    'AbuMuda': const Color(0xffF2F5FF),
    'Putih': const Color(0xffF2F5FF),
    'Merah': const Color(0xffF68484),
  };
}

var authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
      color: OwnColor.colors['Red'] ??
          Colors.black), // Menggunakan warna hitam sebagai default
  borderRadius: const BorderRadius.all(Radius.circular(15)),
);
