import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class CancelAppoinmentDialog extends StatelessWidget {
  final Function onPressYes;
  final Function? onPressNo;

  const CancelAppoinmentDialog(
      {super.key, required this.onPressYes, this.onPressNo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Icon(Icons.warning_amber_rounded,
              size: 50, color: Colors.red.shade600),
          const SizedBox(height: 16),
          const Text(
            'Are you sure to cancel this appointment?',
            style: TextStyle(
                color: Const.aqua, fontWeight: FontWeight.w600, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'You can rebook it later from the canceled appointment menu.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 8,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onPressNo != null) {
                      onPressNo!();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Const.aqua,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('No'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onPressYes();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Yes, Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
