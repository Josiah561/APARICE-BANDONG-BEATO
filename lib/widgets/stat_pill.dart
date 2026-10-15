import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Small rounded label with an icon, used on dark and coloured headers.
class StatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;

  const StatPill({
    super.key,
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = highlighted ? AppColors.ink : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.marker : Colors.white.withAlpha(36),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
          Text(label,
              style: AppText.ui(13, color: fg, weight: FontWeight.w700)),
        ],
      ),
    );
  }
}
