import 'package:Grademaster/Pages/assesment/addsoal.dart';
import 'package:Grademaster/Pages/assesment/assesment.dart';
import 'package:Grademaster/Pages/assesment/rekapsoal.dart';
import 'package:Grademaster/Pages/pengajar/edit_assesment.dart';
import 'package:Grademaster/Pages/pengajar/rekap/bank_soal.dart';
import 'package:Grademaster/Pages/pengajar/rekap/list_pengajar.dart';
import 'package:Grademaster/Pages/pengajar/rekap/siswa_terdaftar.dart';
import 'package:Grademaster/components/material_3_demo/lib/own_component.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePengajar extends StatefulWidget {
  static const nameRoute = '/homepengajar';

  const HomePengajar({super.key});

  @override
  _HomePengajarState createState() => _HomePengajarState();
}

class _HomePengajarState extends State<HomePengajar> {
  List<Map<String, dynamic>> _get = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1/note_app/sesi/list_pengajar.php"),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final validData = (jsonResponse['data'] as List)
              .whereType<Map<String, dynamic>>()
              .toList();
          setState(() {
            _get = validData;
            _isLoading = false;
          });
        } else {
          print(
              "API Error: ${jsonResponse['message'] ?? 'Unexpected data format'}");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _refreshData() {
    _getData(); // Call this to refresh the data
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
              Center(
                child: Text(
                  'Beranda',
                  style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: OwnColor.colors['Putih']),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            const PageBox(),
            PengajarCard(
              data: _get,
              onDelete: _refreshData, // Pass the refresh method here
            ),
          ],
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(),
    );
  }
}

class PageBox extends StatelessWidget {
  const PageBox({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: OwnColor.colors['BiruMuda'],
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.2), // Warna bayangan
        //     spreadRadius: 3, // Sebaran bayangan
        //     blurRadius: 7, // Tingkat blur
        //     offset: Offset(4, 4), // Posisi bayangan (x, y)
        //   )
        // ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 45, // Atur tinggi sesuai kebutuhan
                  child: FloatingActionButton.extended(
                    backgroundColor: OwnColor.colors['Putih'],
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SiswaTerdaftar()),
                    ),
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: OwnColor.colors['Hijau'],
                      ),
                      child: const Icon(
                        Icons.groups,
                        color: Colors.white,
                      ),
                    ),
                    label: Text(
                      'Pelajar Terdaftar',
                      style: TextStyle(
                        color: OwnColor.colors['Hitam'],
                        fontSize: MediaQuery.of(context).size.width * 0.023,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 45, // Atur tinggi sesuai kebutuhan
                  child: FloatingActionButton.extended(
                    backgroundColor: OwnColor.colors['Putih'],
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddSoal()),
                    ),
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: OwnColor.colors['Hijau'],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    label: Text(
                      'Tambah Soal',
                      style: TextStyle(
                        color: OwnColor.colors['Hitam'],
                        fontSize: MediaQuery.of(context).size.width * 0.023,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 45, // Tinggi tombol
                  child: FloatingActionButton.extended(
                    backgroundColor:
                        OwnColor.colors['Putih'], // Warna latar tombol
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PengajarTerdaftar()),
                    ),
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: OwnColor.colors['Hijau'], // Warna latar ikon
                      ),
                      child: const Icon(
                        Icons.man_outlined,
                        color: Colors.white, // Warna ikon
                        size: 20,
                      ),
                    ),
                    label: Text(
                      'Pengajar Terdaftar',
                      style: TextStyle(
                        color: OwnColor.colors['Hitam'], // Warna teks
                        fontSize: MediaQuery.of(context).size.width * 0.023,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 45, // Tinggi tombol
                  child: FloatingActionButton.extended(
                    backgroundColor:
                        OwnColor.colors['Putih'], // Warna latar tombol
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BankSoalPage()),
                    ),
                    icon: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: OwnColor.colors['Hijau'], // Warna latar ikon
                      ),
                      child: const Icon(
                        Icons.collections_bookmark_rounded,
                        color: Colors.white, // Warna ikon
                        size: 20,
                      ),
                    ),
                    label: Text(
                      'Bank Soal',
                      style: TextStyle(
                        color: OwnColor.colors['Hitam'], // Warna teks
                        fontSize: MediaQuery.of(context).size.width * 0.023,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.infinity,
              height: 40,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AssesmentPage()));
                },
                icon: Icon(
                  Icons.add,
                  color: OwnColor.colors['Putih'],
                ),
                backgroundColor: OwnColor.colors['BiruTua'],
                label: Text(
                  'Tambah Assesmen',
                  style: TextStyle(color: OwnColor.colors['Putih']),
                ),
              ))
        ],
      ),
    );
  }
}

class PengajarCard extends StatelessWidget {
  final List<dynamic> data;
  final Function onDelete;

  const PengajarCard({super.key, required this.data, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.isEmpty
            ? 1
            : data
                .length, // Show a single item (like a "no data" message) if empty
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          if (data.isEmpty) {
            // Handle empty data scenario
            return const Center(child: Text(''));
          }

          return AssesmentCardP(
            data: data[index],
            onDelete: (id) {
              print("onDelete called with id: $id"); // Debugging
              onDelete(id);
            },
          );
        },
      ),
    );
  }
}

class AssesmentCardP extends StatefulWidget {
  const AssesmentCardP({super.key, required this.data, required this.onDelete});

  final Map<String, dynamic> data;
  final Function onDelete;

  @override
  _AssesmentCardPState createState() => _AssesmentCardPState();
}

class _AssesmentCardPState extends State<AssesmentCardP> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _soalList = [];

  @override
  void initState() {
    super.initState();
    _getSoal();
  }

  Future<void> _getSoal() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1/note_app/soal_ujian/listview.php"),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true && jsonResponse['data'] is List) {
          final validData = (jsonResponse['data'] as List)
              .whereType<Map<String, dynamic>>()
              .toList();
          if (mounted) {
            setState(() {
              _soalList = validData;
              _isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
          print(
              "API Error: ${jsonResponse['message'] ?? 'Unexpected data format'}");
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(25), boxShadow: [
        customBoxShadow(
          opacity: 0.1,
          blurRadius: 4,
          spreadRadius: 2,
          offset: const Offset(0, 3),
        )
      ]),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
        ),
        onPressed: () {
          if (_soalList.isNotEmpty) {
            final soal =
                _soalList[0]; // Ensure list is not empty before accessing
            final arguments = {
              'id_assesmen': widget.data['id_assesmen'],
              'id_soal': soal['id_soal'],
              'soal': soal['soal'],
              'poin': soal['poin'],
              'pilihan': soal['keterangan_pilihan'],
            };
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    RekapSoal(arguments: arguments),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No soal data available')),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .19,
                  height: MediaQuery.of(context).size.width * .12,
                  child: Text(
                    widget.data['nama_assesmen'] ?? 'Unknown',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * .027,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 4,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .1,
                  height: MediaQuery.of(context).size.width * .1,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        spreadRadius: 0.15,
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.circular(15),
                    color: OwnColor.colors['BiruTua'],
                  ),
                  child: IconDropdown(
                    soal: _soalList.isNotEmpty ? _soalList[0] : {},
                    data: widget.data,
                    onDelete: widget.onDelete,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .26,
                  child: Text(
                    widget.data['nama_kelas'],
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .025,
                        overflow: TextOverflow.ellipsis,
                        color: OwnColor.colors['Hitam']),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        size: 15,
                        color: OwnColor.colors['Hitam'],
                      ),
                      Text(
                        widget.data['tanggal'] ?? 'Unknown',
                        style: TextStyle(
                            fontSize: 10, color: OwnColor.colors['Hitam']),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 15,
                        color: OwnColor.colors['Hitam'],
                      ),
                      Text(
                        widget.data['waktu_mulai'] ?? 'Unknown',
                        style: TextStyle(
                            fontSize: 10, color: OwnColor.colors['Hitam']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconDropdown extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> soal;
  final Function onDelete;

  const IconDropdown(
      {super.key,
      required this.data,
      required this.onDelete,
      required this.soal});

  @override
  _IconDropdownState createState() => _IconDropdownState();
}

class _IconDropdownState extends State<IconDropdown> {
  late final Map<String, dynamic> data;

  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  bool isMenuOpen = false;

  List<Widget> get icons => [
        SizedBox(
          width: MediaQuery.of(context).size.width * .08,
          child: FloatingActionButton.small(
            onPressed: () {
              closeMenu();

              if (widget.data['id_assesmen'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        EditAsessment(arguments: {
                      'id': widget.data['id_assesmen'],
                      'nama_assesmen': widget.data['nama_assesmen'],
                      'ket_assesmen': widget.data['ket_assesmen'],
                      'tanggal': widget.data['tanggal'],
                      'grade_pass': widget.data['grade_pass'],
                      'nama_kelas': widget.data['nama_kelas'],
                    }),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('ID is missing. Cannot navigate to edit page.')),
                );
              }
            },
            elevation: 0,
            child: const Icon(Icons.edit),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .02),
        SizedBox(
          width: MediaQuery.of(context).size.width * .08,
          child: FloatingActionButton.small(
            onPressed: () {
              closeMenu();

              // Ensure both 'id_soal' and 'id_assesmen' are available
              final String idSoal = widget.soal['id_soal'] ?? '';
              final String idAssesmen = widget.data['id_assesmen'] ?? '';

              // Print the IDs for debugging purposes
              print("ID Soal: $idSoal");
              print("ID Assesmen: $idAssesmen");

              if (idAssesmen.isNotEmpty) {
                _confirmDelete(context, idSoal, idAssesmen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('ID is missing. Cannot delete assessment.')),
                );
              }
            },
            elevation: 0,
            child: const Icon(Icons.delete),
          ),
        ),
      ];

  Future<void> _confirmDelete(
      BuildContext context, String idSoal, String idAssesmen) async {
    final bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text("This action cannot be undone."),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      await _deleteAssessment(idSoal, idAssesmen);
    }
  }

  Future<void> _deleteAssessment(String idSoal, String idAssesmen) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/note_app/sesi/delete.php'),
        headers: {
          'Content-Type':
              'application/json', // Ensure the correct content type is set
        },
        body: json.encode({
          'id_soal': idSoal,
          'id_assesmen': idAssesmen,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Assessment deleted successfully')),
          );

          widget.onDelete(); // Call the callback to refresh data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message'] ?? 'Failed to delete assessment'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error occurred: ${response.statusCode}'),
        ));
      }
    } catch (e) {}
  }

  void openMenu() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
    final size = renderBox?.size ?? Size.zero;

    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: position.dy + size.height,
        left: position.dx,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * .12,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 4),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: icons,
            ),
          ),
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry!);

    setState(() {
      isMenuOpen = true;
    });
  }

  void closeMenu() {
    _overlayEntry?.remove();
    setState(() {
      isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: _key,
      icon: const Icon(Icons.more_vert),
      color: Colors.white,
      onPressed: isMenuOpen ? closeMenu : openMenu,
    );
  }
}
