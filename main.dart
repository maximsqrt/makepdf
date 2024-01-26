import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: Container()));
  await Future.delayed(Duration.zero);

  // Get the documents directory
  final Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final String outputPath = '${documentsDirectory.path}/output.pdf';

  // Ensure 'pdf_files' directory exists
  final pdfFilesDirectory = Directory('${documentsDirectory.path}/pdf_files');
  if (!pdfFilesDirectory.existsSync()) {
    pdfFilesDirectory.createSync();
  }

  final pdf = await generatePdf();
  final output = await File(outputPath).writeAsBytes(await pdf.save());

  runApp(
    MaterialApp(
      home: PDFView(
        filePath: output.path,
      ),
    ),
  );
}

Future<pw.Document> generatePdf() async {
  final pdf = pw.Document();

  // Load image from assets
  final ByteData data = await rootBundle.load('assets/detonasiv.png');
  final List<int> bytes = data.buffer.asUint8List();

  try {
    // Decode image
    final ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;

    // Convert image to PDF
    final pdfImage = pw.MemoryImage(
      Uint8List.fromList(
        (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List(),
      ),
    );

    // Add page with the image to the PDF
    const double a4Width = 21.0 * pw.PdfPageFormat.cm;
    const double a4Height = 29.7 * pw.PdfPageFormat.cm;

    pdf.addPage(
      pw.Page(
        pageFormat: pw.PdfPageFormat(a4Width, a4Height),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          );
        },
      ),
    );
  } catch (e) {
    print('Error decoding image: $e');
  }

  return pdf;
}
