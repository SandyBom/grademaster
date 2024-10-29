import 'package:flutter/material.dart';

class BigButtonB extends StatelessWidget {
  const BigButtonB({super.key, required this.label});

  final String label;

  static final actions = [ElevatedButton(onPressed: () {}, child: Text(''))];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
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
  const BigButtonG({super.key, required this.label});

  final String label;

  static final actions = [ElevatedButton(onPressed: () {}, child: Text(''))];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 45,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: OwnColor.colors['Hijau'],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: Text(
                label,
                style: TextStyle(
                  color: OwnColor.colors['Putih'],
                ),
              )),
        ));
  }
}

class MyCheckbox extends StatefulWidget {
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
            TextFormField(
              controller: _controller,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'A',
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
              side: BorderSide(
                  width: BorderSide.strokeAlignOutside, color: Colors.grey))),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          MyCheckbox(),
          SizedBox(
            width: 10,
          ),
          Text(jawaban)
        ],
      ),
    );
  }
}

class OwnForm extends StatelessWidget {
  final String hintText; // Menambahkan parameter hintText
  final String labelText;
  final bool obsecureText; // Menambahkan parameter labelText

  const OwnForm({
    Key? key,
    required this.obsecureText,
    required this.hintText, // Mengharuskan hintText diisi
    required this.labelText, // Mengharuskan labelText diisi
  }) : super(key: key);

  static final authOutlineInputBorder = OutlineInputBorder(
    borderSide:
        BorderSide(color: Colors.grey), // Ganti dengan warna yang diinginkan
    borderRadius: const BorderRadius.all(Radius.circular(15)),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 32, 0, 0),
      height: 55,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          hintText: hintText, // Menggunakan parameter hintText
          labelText: labelText, // Menggunakan parameter labelText
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          border: authOutlineInputBorder,
          enabledBorder: authOutlineInputBorder,
          focusedBorder: authOutlineInputBorder.copyWith(
            borderSide: const BorderSide(color: Color(0xFF214C7A)),
          ),
        ),
      ),
    );
  }
}

class OwnColor {
  static final Map<String, Color> colors = {
    'Biru': Color(0xff64A8F0),
    'Hijau': Color(0xff67C569),
    'BiruTua': Color(0xff214C7A),
    'AbuAbu': Color(0xff908F8F),
    'AbuMuda': Color(0xffF2F5FF),
    'Putih': Color(0xffF2F5FF),
  };
}

var authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
      color: OwnColor.colors['Red'] ??
          Colors.black), // Menggunakan warna hitam sebagai default
  borderRadius: const BorderRadius.all(Radius.circular(15)),
);
