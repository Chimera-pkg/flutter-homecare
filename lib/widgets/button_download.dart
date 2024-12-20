import 'package:flutter/material.dart';
import 'package:flutter_homecare/models/response_product_manual.dart';
import 'package:flutter_homecare/utils.dart';

class ButtonDownload extends StatelessWidget {
  final ResponseProductManual productManual;

  ButtonDownload({required this.productManual});

  @override
  Widget build(BuildContext context) {
    return productManual.file != null
        ? ElevatedButton(
            onPressed: () {
              Utils.launchURL(context, productManual.file!.url.toString());
            },
            child: Text('Download'),
          )
        : Text('File not available');
  }
}
