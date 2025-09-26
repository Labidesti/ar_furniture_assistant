import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer? _timer;
  bool _isEmailVerified = false;
  bool _canResendEmail = false;

  @override
  void initState() {
    super.initState();
    _isEmailVerified = _auth.currentUser!.emailVerified;

    if (!_isEmailVerified) {
      _sendVerificationEmail();

      // Check every 3s if verified
      _timer = Timer.periodic(const Duration(seconds: 3), (_) => _checkEmailVerified());
    }
  }

  Future<void> _checkEmailVerified() async {
    await _auth.currentUser!.reload();
    setState(() {
      _isEmailVerified = _auth.currentUser!.emailVerified;
    });

    if (_isEmailVerified) {
      _timer?.cancel();
      Navigator.pushReplacementNamed(context, "/home"); // redirect to home
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => _canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending email: $e")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Verify Email")),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "A verification email has been sent to your email address. Please check your inbox.",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.email),
            label: const Text("Resend Email"),
            onPressed: _canResendEmail ? _sendVerificationEmail : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Cancel"),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pop(context); // back to login
            },
          ),
        ],
      ),
    ),
  );
}
