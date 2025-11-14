import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/service_locator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class FileViewerPage extends StatefulWidget {
  final String? path;
  final String? url;

  const FileViewerPage({super.key, this.path, this.url});

  @override
  State<FileViewerPage> createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
  late Future<Uint8List> _fileBytesFuture;
  bool _isPdf = false;

  @override
  void initState() {
    super.initState();

    String? source = widget.url ?? widget.path;
    if (source != null && source.toLowerCase().endsWith('.pdf')) {
      _isPdf = true;
    }

    // Load bytes
    if (widget.url != null) {
      _fileBytesFuture = _downloadFile(widget.url!);
    } else if (widget.path != null) {
      _fileBytesFuture = _loadLocalFile(widget.path!);
    } else {
      _fileBytesFuture = Future.error(Exception("No file source provided."));
    }
  }

  Future<Uint8List> _downloadFile(String url) async {
    final response = await sl<Dio>().get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  Future<Uint8List> _loadLocalFile(String path) async {
    File file = File(path);
    return await file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'File Preview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<Uint8List>(
        future: _fileBytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (_isPdf) {
                return SfPdfViewer.memory(snapshot.data!);
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(snapshot.data!),
                  ),
                );
              }
            } else {
              return Center(
                  child: Text('Failed to load file: ${snapshot.error}'));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
