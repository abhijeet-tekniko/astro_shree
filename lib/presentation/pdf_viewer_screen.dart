import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../widget/app_bar/custom_navigate_back_button.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl; // Changed from pdfPath to pdfUrl
  const PdfViewerScreen({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() => _isLoading = true);
    try {

      print('pdfUrllllllll====${widget.pdfUrl}');
      // Download the PDF using Dio
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_pdf.pdf';
      final dio = Dio();
      await dio.download(widget.pdfUrl, filePath);

      setState(() {
        _localPath = filePath;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading PDF: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clean up the temporary file when the widget is disposed
    if (_localPath != null) {
      File(_localPath!).delete().catchError((e) {
        print('Error deleting temporary file: $e');
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomNavigationButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Invoice',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFFC62828),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _localPath != null
          ? PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onError: (error) {
          print('PDF Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading PDF: $error')),
          );
        },
        onPageError: (page, error) {
          print('Page $page error: $error');
        },
        onRender: (pages) {
          print('PDF rendered with $pages pages');
        },
      )
          : const Center(child: Text('Failed to load PDF')),
    );
  }
}