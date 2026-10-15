import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Success (green) or error (red) message shown directly on the screen.
class StatusBanner extends StatelessWidget {
  final String message;
  final bool isError;
  final VoidCallback? onClose;
  final EdgeInsets margin;

  const StatusBanner({
    super.key,
    required this.message,
    required this.isError,
    this.onClose,
    this.margin = const EdgeInsets.fromLTRB(16, 12, 16, 0),
  });

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.danger : AppColors.success;
    return Container(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(90)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppText.ui(14, color: color, weight: FontWeight.w600),
            ),
          ),
          if (onClose != null)
            IconButton(
              tooltip: 'Dismiss',
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 18, color: color),
              onPressed: onClose,
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );
  }
}
