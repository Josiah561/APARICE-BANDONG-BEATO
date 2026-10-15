import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Horizontal filter: All, or one author (1-10).
class AuthorChips extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onSelected;

  const AuthorChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
        itemCount: 11,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final author = i == 0 ? null : i;
          final isSelected = selected == author;
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onSelected(author),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.ink : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.ink : AppColors.line,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (author != null) ...[
                    Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.author(author),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 7),
                  ],
                  Text(
                    author == null ? 'All posts' : 'Author $author',
                    style: AppText.ui(
                      13.5,
                      weight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
