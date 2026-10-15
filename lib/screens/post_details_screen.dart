import 'package:flutter/material.dart';

import '../boxes.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/stat_pill.dart';
import '../widgets/status_banner.dart';

class PostDetailsScreen extends StatefulWidget {
  const PostDetailsScreen({super.key});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  String? _message;
  bool _messageIsError = false;

  // CREATE: put() with the post id as key, so a post is never saved twice
  void _saveToFavorites(Map<String, dynamic> post) {
    final id = post['id'];
    setState(() {
      if (favoritesBox.containsKey(id)) {
        _messageIsError = true;
        _message = 'This post is already in your favorites.';
      } else {
        favoritesBox.put(id, {
          'id': id,
          'title': post['title'],
          'body': post['body'],
          'note': '',
        });
        _messageIsError = false;
        _message = 'Saved to favorites.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Arguments passed by Navigator.pushNamed from the Posts screen
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int id = args['id'] as int;
    final String rawBody = args['body'] as String;
    final author = authorOf(id);
    final color = AppColors.author(author);
    final isSaved = favoritesBox.containsKey(id);
    final body = capitalize(rawBody.replaceAll('\n', '\n\n'));

    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Post $id'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            StatPill(
                              icon: Icons.person_outline,
                              label: 'Author $author',
                            ),
                            StatPill(
                              icon: Icons.schedule,
                              label: '${readingMinutes(rawBody)} min read',
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isSaved
                                  ? const StatPill(
                                      key: ValueKey('saved'),
                                      icon: Icons.bookmark,
                                      label: 'Saved',
                                      highlighted: true,
                                    )
                                  : const SizedBox.shrink(
                                      key: ValueKey('not-saved')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          capitalize(args['title'] as String),
                          style: AppText.heading(31,
                              color: Colors.white, height: 1.2),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(22, 30, 22, 30),
                      decoration: const BoxDecoration(
                        color: AppColors.paper,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Text(body,
                          style: AppText.reading(18, height: 1.75)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: const BoxDecoration(
            color: AppColors.paper,
            border: Border(top: BorderSide(color: AppColors.line)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_message != null)
                StatusBanner(
                  message: _message!,
                  isError: _messageIsError,
                  margin: const EdgeInsets.only(bottom: 12),
                ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  style: isSaved
                      ? FilledButton.styleFrom(
                          backgroundColor: AppColors.marker,
                          foregroundColor: AppColors.ink,
                        )
                      : null,
                  onPressed: () => _saveToFavorites(args),
                  icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  label: Text(
                      isSaved ? 'Saved to favorites' : 'Save to favorites'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
