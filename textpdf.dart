// import 'dart:html';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:pdf/pdf.dart' as pw;
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MaterialApp(home: Container()));
//   await Future.delayed(Duration.zero);

//   try {
//     final pdf = await generatePdf();
//     final Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     final String outputPath = '${documentsDirectory.path}/output.pdf';
//     final output = await File(outputPath).writeAsBytes(await pdf.save());

//     runApp(
//       MaterialApp(
//         home: PDFView(path: output.path),
//       ),
//     );
//   } catch (e) {
//     print('Error creating PDF: $e');
//   }
// }

// Future<pw.Document> generatePdf() async {
//   final pdf = pw.Document();

//   try {
//     const String text = 'Hello, PDF!';
//     pdf.addPage(pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Text(text),
//         );
//       },
//     ));
//   } catch (e) {
//     print('Error generating PDF: $e');
//   }

//   return pdf;
// }
