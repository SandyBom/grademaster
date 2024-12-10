import 'package:flutter/material.dart';
import 'package:grademaster/Pages/assesment/addsoal.dart';
import 'package:grademaster/Pages/assesment/assesment.dart';
import 'package:grademaster/Pages/assesment/rekapsoal.dart';
import 'package:grademaster/Pages/pengajar/edit_assesment.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';
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
        Uri.parse("http://127.0.0.1/note_app/sesi/list.php"),
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
                child: Text(
                  'Beranda',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _get.isEmpty
                ? const Center(child: Text('No data available'))
                : Column(
                    children: [
                      PageBox(),
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
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(),
    );
  }
}

class PageBox extends StatelessWidget {
  const PageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: OwnColor.colors['BiruTua'],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenWidth * 0.35,
                child: ElevatedButton.icon(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('Mahasiswa Terdaftar',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.023)),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.35,
                child: ElevatedButton.icon(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('Mahasiswa Terdaftar',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.023)),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              height: 40,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AssesmentPage()));
                },
                icon: const Icon(Icons.add),
                backgroundColor: OwnColor.colors['Putih'],
                label: const Text('Tambah Assesmen'),
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          if (data.isEmpty) {
            // Handle empty data scenario
            return Center(child: Text('No data available'));
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
  const AssesmentCardP({Key? key, required this.data, required this.onDelete})
      : super(key: key);

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
        Uri.parse("http://127.0.0.1/note_app/soal_ujian/list.php"),
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
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.zero),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * .002),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .17,
                    height: MediaQuery.of(context).size.width * .12,
                    child: Text(
                      widget.data['nama_assesmen'] ?? 'Unknown',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .03,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 4,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .1,
                    height: MediaQuery.of(context).size.width * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                  Container(
                    width: MediaQuery.of(context).size.width * .26,
                    child: Text(
                      widget.data['nama_kelas'],
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * .032,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                          size: MediaQuery.of(context).size.width * .02,
                        ),
                        Text(
                          widget.data['tanggal'],
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .018,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: MediaQuery.of(context).size.width * .02,
                        ),
                        Text(
                          widget.data['grade_pass'],
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * .018,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      {Key? key,
      required this.data,
      required this.onDelete,
      required this.soal})
      : super(key: key);

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
                  SnackBar(
                      content:
                          Text('ID is missing. Cannot navigate to edit page.')),
                );
              }
            },
            child: const Icon(Icons.edit),
            elevation: 0,
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

              if (idSoal.isNotEmpty && idAssesmen.isNotEmpty) {
                _confirmDelete(context, idSoal, idAssesmen);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('ID is missing. Cannot delete assessment.')),
                );
              }
            },
            child: const Icon(Icons.delete),
            elevation: 0,
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
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

    Overlay.of(context)?.insert(_overlayEntry!);

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
