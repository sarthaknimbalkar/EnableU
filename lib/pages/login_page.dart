import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/components/text_field.dart';
import 'package:fyp/components/button.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Show loading indicator
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing while loading
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  // Display error message
  void _displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Login function
  void _login() async {
    _showLoadingDialog();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
      Navigator.pop(context); // Close loading dialog on success
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close loading dialog on error
      _displayMessage(e.message ?? "An error occurred. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView( // Changed to ListView for scrollable flexibility
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        children: [
          const SizedBox(height: 50),
          const Center(
            child: Text(
              'Welcome back',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Email text field
          MyTextField(
            controller: emailTextController,
            hintText: 'Email',
            obscureText: false,
          ),
          const SizedBox(height: 20),
          // Password text field
          MyTextField(
            controller: passwordTextController,
            hintText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 30),
          // Login button
          MyButton(
            onTap: _login,
            text: 'Login',
          ),
          const SizedBox(height: 25),
          // Register link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Not registered yet?',
                style: TextStyle(color: Colors.grey[700]),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: const Text(
                  ' Register now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50), // Extra padding for bottom overflow prevention
        ],
      ),
    );
  }
}
