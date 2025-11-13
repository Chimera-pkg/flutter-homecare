import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/material.dart';

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({required this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Preview'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 70.0),
        child: PDFView(
          filePath: widget.path,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: true,
          pageSnap: true,
          defaultPage: 0,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
        ),
      ),
    );
  }
}
