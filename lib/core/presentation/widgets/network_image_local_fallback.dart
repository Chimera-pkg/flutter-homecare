import 'package:flutter/material.dart';

class NetworkImageWithLocalFallback extends StatelessWidget {
  final String imageUrl;
  final String localAsset;

  NetworkImageWithLocalFallback({
    required this.imageUrl,
    required this.localAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 100.0,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Here we can log the error to our analytics or error monitoring service.
        print('Error loading $imageUrl: $exception');

        // Returning a local asset image
        return Image.asset(
          localAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 100.0,
          alignment: Alignment.center,
        );
      },
    );
  }
}
