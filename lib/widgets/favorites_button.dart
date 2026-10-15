import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../boxes.dart';
import '../theme/app_theme.dart';

/// AppBar action that opens Favorites. Turns marker-yellow once something is saved.
class FavoritesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FavoritesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: favoritesBox.listenable(),
      builder: (context, Box box, _) {
        final hasItems = box.isNotEmpty;
        final fg = hasItems ? AppColors.ink : Colors.white;
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Tooltip(
            message: 'Favorites',
            child: Material(
              color: hasItems ? AppColors.marker : Colors.transparent,
              clipBehavior: Clip.antiAlias,
              shape: StadiumBorder(
                side: BorderSide(
                  color: hasItems ? Colors.transparent : Colors.white54,
                ),
              ),
              child: InkWell(
                onTap: onPressed,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasItems ? Icons.bookmark : Icons.bookmark_border,
                        size: 19,
                        color: fg,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${box.length}',
                        style: AppText.ui(14.5,
                            color: fg, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
