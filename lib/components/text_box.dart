import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12), // Slightly rounded corners for a smoother look
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), // More balanced padding
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Symmetric margins for consistency
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section name with improved style
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold, // Made section name bold for emphasis
                  fontSize: 16.0,
                ),
              ),
              // Edit button
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[600],
                ),
                splashRadius: 20, // Added splash radius for better interaction
              ),
            ],
          ),
          // Text content with better readability
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // Added space between section and text
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black87, // Darker color for better contrast
                fontSize: 14.0, // Adjusted font size for improved readability
              ),
            ),
          ),
        ],
      ),
    );
  }
}
