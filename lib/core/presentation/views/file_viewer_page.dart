import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:m2health/service_locator.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.white, size: 48),
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
          } else if (snapshot.hasData) {
            if (_isPdf) {
              return SfPdfViewer.memory(
                snapshot.data!,
                enableDoubleTapZooming: true,
              );
            } else {
              return PhotoView(
                imageProvider: MemoryImage(snapshot.data!),
                // Min scale: Contained (Fits screen, centered)
                minScale: PhotoViewComputedScale.contained,
                // Max scale: Covers screen * 4 (allows zooming in detail)
                maxScale: PhotoViewComputedScale.covered * 4,
                // Initial scale
                initialScale: PhotoViewComputedScale.contained,
                // Background color (matches Scaffold)
                backgroundDecoration: const BoxDecoration(color: Colors.black),
                // Custom error builder
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Could not render image',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
                // Optional: Hero tag if you want smooth transitions from list
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
}
