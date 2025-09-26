import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'home_screen.dart';
import 'verify_email_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 1️⃣ Simulate network delay (optional)
      await Future.delayed(const Duration(seconds: 1));

      // 2️⃣ Firebase user check
      final user = auth.currentUser;
      if (user == null) {
        // No user → back to login
        Navigator.pushReplacementNamed(context, "/");
        return;
      }

      await user.reload();
      if (!user.emailVerified) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
        );
        return;
      }

      // 3️⃣ Preload catalog JSON
      await _preloadProducts();

      // 4️⃣ Navigate to Home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      debugPrint("Loading Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading app: $e")),
      );
    }
  }

  Future<void> _preloadProducts() async {
    final jsonString = await rootBundle.loadString('assets/data/products.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    debugPrint("✅ Preloaded ${data.keys.length} categories from JSON");
    // You could store it in a Provider/Singleton if you want
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text("Preparing your furniture catalog...",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
