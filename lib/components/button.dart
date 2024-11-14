import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final double padding;
  final double borderRadius;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
    this.padding = 16.0,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: Colors.grey.withOpacity(0.3),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
