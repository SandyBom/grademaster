// import 'package:flutter/material.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:open_file/open_file.dart';

// class MyPdfPage extends StatelessWidget {
//   const MyPdfPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("PDF Viewer")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _generateAndShowPdf(context);
//           },
//           child: const Text("Buat dan Tampilkan PDF"),
//         ),
//       ),
//     );
//   }

//   // Fungsi untuk membuat dan menampilkan PDF
//   Future<void> _generateAndShowPdf(BuildContext context) async {
//     // Buat dokumen PDF baru
//     final pdf = pw.Document();

//     // Tambahkan halaman dengan konten
//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text('Halo, ini adalah PDF pertama saya!'),
//           );
//         },
//       ),
//     );

//     // Dapatkan direktori aplikasi untuk menyimpan file PDF
//     final output = await getTemporaryDirectory();
//     final filePath = '${output.path}/example.pdf';

//     // Simpan dokumen PDF ke file
//     final file = File(filePath);
//     await file.writeAsBytes(await pdf.save());

//     // Buka file PDF menggunakan viewer eksternal
//     OpenFile.open(filePath);
//   }
// }

// void main() {
//   runApp(const MaterialApp(home: MyPdfPage()));
// }
