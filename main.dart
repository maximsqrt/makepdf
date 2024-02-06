import 'dart:io'; //provides classes that command-line apps can use for accessing HTTP resources, as well as running HTTP servers.
import 'dart:typed_data';
// ignore: unused_import
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:pdf/pdf.dart' as pw;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

// Main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pdfPath = await generatePdf();
  runApp(
    MaterialApp(
      home: PDFView(
        filePath: pdfPath,
      ),
    ),
  );
}

// Function to generate PDF
Future<String> generatePdf() async {
  // Initialize PDF document
  final pdf = pw.Document();

  // Load image from assets
  final ByteData imageData = await rootBundle.load('assets/detonasiv.png');
  final Uint8List bytes = imageData.buffer.asUint8List();

  // Convert image data to PDF image
  final pdfImage = pw.MemoryImage(Uint8List.fromList(bytes));

  // Define different sizes for the image
  final List<pw.Widget> images = [
    pw.SizedBox(width: 100, height: 100, child: pw.Image(pdfImage)),
    pw.SizedBox(width: 200, height: 200, child: pw.Image(pdfImage)),
    pw.SizedBox(width: 300, height: 300, child: pw.Image(pdfImage)),
  ];

  // Add pages to the PDF with the images
  for (final imageWidget in images) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: imageWidget,
          );
        },
      ),
    );
  }

  // Get the documents directory
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();

  // Create the directory if it doesn't exist
  final pdfFilesDirectory = Directory('${documentsDirectory.path}/pdf_files');
  if (!pdfFilesDirectory.existsSync()) {
    pdfFilesDirectory.createSync();
  }

  // Generate a unique filename for the PDF
  final String pdfFileName = 'output_${DateTime.now().millisecondsSinceEpoch}.pdf';

  // Save the PDF file
  final String pdfFilePath = '${pdfFilesDirectory.path}/$pdfFileName';
  await File(pdfFilePath).writeAsBytes(await pdf.save());

  // Return the filepath of the generated PDF
  return pdfFilePath;
}