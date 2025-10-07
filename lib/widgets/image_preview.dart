import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePreview extends StatelessWidget {
  final Function(File?) onChooseImage;
  final File? imageFile;
  final String helperText;

  const ImagePreview({
    super.key,
    required this.onChooseImage,
    this.imageFile,
    this.helperText = 'Image less than 10MB',
  });

  Future<void> _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final newImage = File(pickedFile.path);
      onChooseImage(newImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: imageFile == null
                ? Center(child: Image.asset('assets/icons/ic_preview.png'))
                : Image.file(imageFile!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                helperText,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: _chooseImage,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF10B981)),
                ),
                child: const Text(
                  'Choose File',
                  style: TextStyle(color: Color(0xFF10B981)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
