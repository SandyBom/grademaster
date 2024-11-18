import 'package:flutter/material.dart';

class BigButtonB extends StatelessWidget {
  const BigButtonB({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

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
  const BigButtonG({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

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
  const MyForm({required this.valueAnswer});
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
                maxLines: null,
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

class MyAnswer extends StatelessWidget {
  const MyAnswer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      width: double.infinity,
      height: 45,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
              width: BorderSide.strokeAlignOutside, color: Colors.grey),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [MyCheckbox(), Text('vasjdnaksvdajskdnkas dgasbdkj')],
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
      margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
      width: double.infinity,
      height: 45,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
              width: BorderSide.strokeAlignOutside, color: Colors.grey),
        ),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            soal,
            maxLines: null,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            child: Row(
              children: [
                FloatingActionButton.extended(
                  onPressed: () {},
                  elevation: 0,
                  label: Row(
                    children: [Text('Edit'), Icon(Icons.edit)],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton.extended(
                  onPressed: () {},
                  elevation: 0,
                  label: Row(
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

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: 55,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['Hijau'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Text('Next')));
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: 55,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['AbuAbu'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Text('Previous')));
  }
}

class FinalButton extends StatelessWidget {
  const FinalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
        height: 55,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(),
        child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: OwnColor.colors['BiruTua'],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: Text('Final Attempt')));
  }
}

class IconDropdown extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<IconDropdown> {
  final GlobalKey _key = LabeledGlobalKey("button_icon");
  OverlayEntry? _overlayEntry;
  Size buttonSize = Size.zero;
  Offset buttonPosition = Offset.zero;
  bool isMenuOpen = false;

  List<FloatingActionButton> icons = [
    FloatingActionButton.small(
      onPressed: () {},
      child: Icon(Icons.edit),
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
    FloatingActionButton.small(
      onPressed: () {},
      child: Icon(Icons.delete),
      elevation: 0,
      backgroundColor: Colors.transparent,
    ),
  ];

  void findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        top: buttonPosition.dy + buttonSize.height,
        left: buttonPosition.dx,
        width: buttonSize.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: icons.length * buttonSize.height,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Theme(
              data: ThemeData(
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  icons.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        // Handle icon tap
                        print('Icon ${index + 1} tapped');
                        closeMenu(); // Close menu on selection
                      },
                      child: Container(
                        width: buttonSize.width,
                        height: buttonSize.height,
                        alignment: Alignment.center, // Center the icon
                        child: icons[index],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void openMenu() {
    findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      isMenuOpen = true; // Update state to reflect that the menu is open
    });
  }

  void closeMenu() {
    _overlayEntry?.remove();
    setState(() {
      isMenuOpen = false; // Update state to reflect that the menu is closed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: OwnColor.colors['BiruTua'], // Use a valid color
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(Icons.more_vert),
        color: Colors.white,
        onPressed: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
      ),
    );
  }
}

class OwnColor {
  static final Map<String, Color> colors = {
    'Biru': Color(0xff64A8F0),
    'BiruMuda': Color(0xffF2F5FF),
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
