import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class FeedbackSuccessPage extends StatelessWidget {
  final Function onButtonPressed;
  const FeedbackSuccessPage({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/ic_checklist.png',
                width: 142,
                height: 142,
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank you for your feedback!',
                style: TextStyle(
                  color: Const.aqua,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'This appointment has been completed and can be viewed in the completed orders menu',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () {
                      onButtonPressed();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Const.aqua,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View Detail',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
