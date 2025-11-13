import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// A widget for selecting and previewing an image.
///
/// Displays a preview of the selected [imageFile] or an [initialImageUrl].
/// If neither is available, a placeholder is shown. Tapping the 'Choose File'
/// button opens the image gallery to select a new image.
class ImagePreview extends StatelessWidget {
  /// A callback function that is triggered when a new image is selected.
  final Function(File?) onChooseImage;

  /// The local image file to be displayed. This takes precedence over [initialImageUrl].
  final File? imageFile;

  /// The URL of an initial image to display. Used when no [imageFile] is available.
  final String? initialImageUrl;

  /// A small descriptive text displayed beside the button.
  final String helperText;

  const ImagePreview({
    super.key,
    required this.onChooseImage,
    this.imageFile,
    this.initialImageUrl,
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

  /// Builds the image preview based on the available sources.
  Widget _buildImage() {
    // Priority 1: Display the newly picked local file.
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    // Priority 2: Display the initial network image URL.
    if (initialImageUrl != null && initialImageUrl!.isNotEmpty) {
      return Image.network(
        initialImageUrl!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error_outline, color: Colors.red);
        },
      );
    }
    // Priority 3: Display the placeholder if no image is available.
    return Center(child: Image.asset('assets/icons/ic_preview.png'));
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
            child: _buildImage(),
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
