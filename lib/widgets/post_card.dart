import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'author_badge.dart';
import 'highlighted_text.dart';

/// One post in the list. Saved posts get a marker on the title
/// and a yellow bookmark in the corner.
class PostCard extends StatelessWidget {
  final Map post;
  final bool isSaved;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.isSaved,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final int id = post['id'] as int;
    final String body = post['body'] as String;
    final author = authorOf(id);
    final color = AppColors.author(author);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withAlpha(16),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthorBadge(author: author),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 26),
                              child: HighlightedText(
                                text: capitalize(post['title'] as String),
                                highlighted: isSaved,
                                maxLines: 2,
                                style: AppText.heading(17.5, height: 1.3),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              capitalize(oneLine(body)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.reading(14.5,
                                  color: AppColors.muted, height: 1.45),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Author $author',
                                  style: AppText.ui(12.5,
                                      color: AppColors.muted,
                                      weight: FontWeight.w600),
                                ),
                                const Spacer(),
                                const Icon(Icons.schedule,
                                    size: 14, color: AppColors.muted),
                                const SizedBox(width: 4),
                                Text(
                                  '${readingMinutes(body)} min',
                                  style: AppText.ui(12.5,
                                      color: AppColors.muted,
                                      weight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSaved)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.marker,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark,
                          size: 16, color: AppColors.ink),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
