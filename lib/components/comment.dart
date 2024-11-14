import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  final Color backgroundColor;
  final Color textColor;
  final Color userInfoColor;
  final double padding;
  final double borderRadius;

  const Comment({
    super.key,
    required this.user,
    required this.text,
    required this.time,
    this.backgroundColor = const Color(0xFFE0E0E0), // light gray
    this.textColor = Colors.black,
    this.userInfoColor = Colors.grey,
    this.padding = 12.0,
    this.borderRadius = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment text
          Text(
            text,
            style: TextStyle(color: textColor),
          ),
          const SizedBox(height: 6),
          // User and time info
          Row(
            children: [
              Text(user, style: TextStyle(color: userInfoColor)),
              const SizedBox(width: 4),
              Text("-", style: TextStyle(color: userInfoColor)),
              const SizedBox(width: 4),
              Text(time, style: TextStyle(color: userInfoColor)),
            ],
          ),
        ],
      ),
    );
  }
}
