import 'dart:io';

import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/widgets/image_preview.dart';

class TeleradiologyDetail extends StatefulWidget {
  @override
  _TeleradiologyDetailState createState() => _TeleradiologyDetailState();
}

class _TeleradiologyDetailState extends State<TeleradiologyDetail> {
  bool ctScanChecked = false;
  bool mriScanChecked = false;
  bool mammogramScanChecked = false;

  final List<File?> _images = List.filled(3, null);

  Future<void> setImageAt(int index, File? image) async {
    setState(() {
      _images[index] = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Teleradiology',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Disease Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.grey),
            const Text(
              'Disease History Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'E.g Diptheria, Pneumonia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Other Biomakers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter disease history description here...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Patient Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter other biomarker information here...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Radiology Images',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(color: Colors.grey),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: ctScanChecked,
                      onChanged: (value) {
                        setState(() {
                          ctScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'CT Scan',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImagePreview(
              imageFile: _images[0],
              onChooseImage: (image) => setImageAt(0, image),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: mriScanChecked,
                      onChanged: (value) {
                        setState(() {
                          mriScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'MRI Scan',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImagePreview(
              imageFile: _images[1],
              onChooseImage: (image) => setImageAt(1, image),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: mammogramScanChecked,
                      onChanged: (value) {
                        setState(() {
                          mammogramScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Mammogram',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ImagePreview(
              imageFile: _images[2],
              onChooseImage: (image) => setImageAt(2, image),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: mammogramScanChecked,
                      onChanged: (value) {
                        setState(() {
                          mammogramScanChecked = value!;
                        });
                      },
                      activeColor: Const.tosca,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Mammogram',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(Icons.info_outline, color: Colors.grey),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Medical Opinion',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(),
            const Text(
              '** Information below will be provided by Medical Professionals only',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const SizedBox(height: 20),
            const Text(
              'Diagnostic opinion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'E.g Diptheria, Pneumonia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Recommendation Opinion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'E.g Diptheria, Pneumonia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 350, // Ubah ukuran sesuai kebutuhan
              height: 50, // Ubah ukuran sesuai kebutuhan
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
