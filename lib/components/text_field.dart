import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData? icon; // Optional icon for additional functionality (e.g., password visibility toggle)
  final String? errorText; // Optional error message for validation

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), // Consistent margin
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey[600]) : null, // Optional icon
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade400, // Lighter border color when not focused
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue.shade500, // Border color when focused
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          errorText: errorText, // Show error text if provided
        ),
      ),
    );
  }
}
