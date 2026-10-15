import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Dark panel under the AppBar with soft circles behind the content.
class HeaderPanel extends StatelessWidget {
  final Widget child;

  const HeaderPanel({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: Container(
        width: double.infinity,
        color: AppColors.ink,
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -60,
              child: _circle(190, AppColors.primary.withAlpha(90)),
            ),
            Positioned(
              left: -40,
              bottom: -70,
              child: _circle(150, AppColors.marker.withAlpha(36)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}
