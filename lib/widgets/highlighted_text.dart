import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Text with a highlighter-marker background when [highlighted] is true.
/// When the flag changes the marker fades in.
class HighlightedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool highlighted;
  final int? maxLines;

  const HighlightedText({
    super.key,
    required this.text,
    required this.style,
    required this.highlighted,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(end: highlighted ? AppColors.marker : Colors.transparent),
      duration: const Duration(milliseconds: 450),
      builder: (context, color, _) => Text(
        text,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
        style: style.copyWith(backgroundColor: color),
      ),
    );
  }
}
