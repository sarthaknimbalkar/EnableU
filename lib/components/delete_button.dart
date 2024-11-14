import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  final Color color;
  final double iconSize;

  const DeleteButton({
    super.key,
    required this.onTap,
    this.color = Colors.grey,
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
          child: Tooltip(
            message: 'Delete',
            child: Icon(
              Icons.delete,
              color: color,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
