import 'package:flutter/material.dart';
import 'package:recipe/view/screen/main_navigation.dart';
import 'splash_screen.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(primarySwatch: Colors.orange),
      // Routing menggunakan named routes
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
      // Gunakan onGenerateRoute untuk menangani MainNavigation dengan argumen
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final user = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => MainNavigation(user: user),
          );
        }
        return null; // Kembalikan null jika rute tidak dikenali
      },
    );
  }
}
