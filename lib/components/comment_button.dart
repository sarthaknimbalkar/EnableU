import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  const CommentButton({
    super.key,
    required this.onTap,
    this.icon = Icons.comment,
    this.iconColor = Colors.grey,
    this.iconSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(iconSize / 2),
        splashColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: iconColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}
