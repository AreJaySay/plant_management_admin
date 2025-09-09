import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:plant_management/screens/reports/components/chart.dart';
import 'package:printing/printing.dart';
class Print extends StatefulWidget {
  @override
  State<Print> createState() => _PrintState();
}

class _PrintState extends State<Print> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 900,
      height: 600,
      child: PdfPreview(
        build: (format) => _generatePdf(format, "Document to print"),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font,fontSize: 30)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Flexible(child: pw.Chart(
                  grid: pw.PieGrid(),
                  datasets: [])),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }
}