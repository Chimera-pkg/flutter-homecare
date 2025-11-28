import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:m2health/service_locator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';

class FileViewerPage extends StatefulWidget {
  final String? path;
  final String? url;
  final String? title;

  const FileViewerPage({super.key, this.path, this.url, this.title});

  @override
  State<FileViewerPage> createState() => _FileViewerPageState();
}

class _FileViewerPageState extends State<FileViewerPage> {
  late Future<Uint8List> _fileBytesFuture;
  bool _isPdf = false;
  String _fileName = 'File Preview';

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  void _loadFile() {
    String? source = widget.url ?? widget.path;

    if (source == null) {
      _fileBytesFuture = Future.error("No file source provided.");
      return;
    }

    // Determine File Type
    final uri = Uri.parse(source);
    final pathWithoutQuery = uri.path;
    final ext = p.extension(pathWithoutQuery).toLowerCase();

    if (ext == '.pdf') {
      _isPdf = true;
    }

    // Set Title
    if (widget.title != null) {
      _fileName = widget.title!;
    } else {
      _fileName = p.basename(pathWithoutQuery).replaceAll('%20', ' ');
    }

    // Load Bytes
    setState(() {
      if (widget.url != null) {
        _fileBytesFuture = _downloadFile(widget.url!);
      } else {
        _fileBytesFuture = _loadLocalFile(widget.path!);
      }
    });
  }

  Future<Uint8List> _downloadFile(String url) async {
    try {
      final response = await sl<Dio>().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (e) {
      throw Exception("Failed to download file: $e");
    }
  }

  Future<Uint8List> _loadLocalFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return await file.readAsBytes();
    }
    throw Exception("Local file not found");
  }

  /// flutter_pdfview requires a File Path, it cannot read raw bytes directly.
  /// This helper writes the memory bytes to a temp file.
  Future<String> _writeBytesToTempFile(Uint8List bytes) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp_viewer.pdf');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          _fileName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: FutureBuilder<Uint8List>(
        future: _fileBytesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _buildErrorWidget();
          } else if (snapshot.hasData) {
            if (_isPdf) {
              // PDF Handling
              return FutureBuilder<String>(
                // Convert bytes to temp file for the viewer
                future: _writeBytesToTempFile(snapshot.data!),
                builder: (context, pathSnapshot) {
                  if (pathSnapshot.hasData) {
                    return PDFView(
                      filePath: pathSnapshot.data!,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageFling: false,
                      onError: (error) {
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        print('$page: ${error.toString()}');
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              );
            } else {
              // Image Handling
              return PhotoView(
                imageProvider: MemoryImage(snapshot.data!),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Could not render image',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.url ?? widget.path ?? "image"),
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 48),
          const SizedBox(height: 16),
          const Text('Failed to load file',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadFile,
            child: const Text('Retry'),
          )
        ],
      ),
    );
  }
}
