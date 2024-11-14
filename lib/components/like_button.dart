import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(isLiked), // Ensures a smooth transition
          color: isLiked ? Colors.red : Colors.grey,
          size: 30.0, // Consistent size for the icon
        ),
      ),
    );
  }
}
