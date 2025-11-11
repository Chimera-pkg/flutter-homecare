import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
import 'package:m2health/const.dart'; // Import constants

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/icons/icon_heart.png', // Ganti dengan path ikon kustom Anda
              width: 30, // Sesuaikan ukuran ikon
              height: 30, // Sesuaikan ukuran ikon
            ),
            const SizedBox(width: 10),
            const Text('M2Health Care',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Const.tosca)),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Simplify homecare bookings with expert Healthcare Specialists at your fingertips!',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/splash.png', // Ganti dengan path ilustrasi Anda
              width: 394,
              height: 394,
            ),
            const SizedBox(height: 20),
            // SizedBox(
            //   width: 357,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       context.go('/dasboard');
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Const.tosca,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     child: const Text(
            //       'Get Started',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
            SizedBox(
              width: 357,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/sign-in');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Handle tap
              },
              child: const Text(
                'Powered by MedMap',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
