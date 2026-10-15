import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Coloured square showing the author number.
class AuthorBadge extends StatelessWidget {
  final int author;
  final double size;

  const AuthorBadge({super.key, required this.author, this.size = 52});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.author(author),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Text(
        '$author',
        style: AppText.heading(size * 0.46, color: Colors.white, height: 1),
      ),
    );
  }
}
