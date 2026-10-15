import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Used for errors, empty lists and empty search results:
/// says what happened and what to do next.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 92,
            height: 92,
            decoration: const BoxDecoration(
              color: AppColors.marker,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 42, color: AppColors.ink),
          ),
          const SizedBox(height: 22),
          Text(title,
              textAlign: TextAlign.center, style: AppText.heading(24)),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.reading(16, color: AppColors.muted),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 24),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
