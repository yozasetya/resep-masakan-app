import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login', // Navigasi ke LoginPage
        (route) => false, // Hapus semua rute sebelumnya
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'images/Splash Screen.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
