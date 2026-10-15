import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../boxes.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/author_badge.dart';
import '../widgets/empty_state.dart';
import '../widgets/header_panel.dart';
import '../widgets/highlighted_text.dart';
import '../widgets/note_dialog.dart';
import '../widgets/stat_pill.dart';
import '../widgets/status_banner.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String? _message;
  bool _messageIsError = false;

  // UPDATE: edit the personal note and save it back to the box
  Future<void> _editNote(Map post) async {
    final newNote = await showDialog<String>(
      context: context,
      builder: (context) =>
          NoteDialog(initialNote: (post['note'] ?? '') as String),
    );
    if (newNote == null) return;

    final updated = Map<String, dynamic>.from(post);
    updated['note'] = newNote;
    await favoritesBox.put(post['id'], updated);
    setState(() {
      _messageIsError = false;
      _message = newNote.isEmpty ? 'Note removed.' : 'Note saved.';
    });
  }

  // DELETE
  Future<void> _delete(Map post) async {
    await favoritesBox.delete(post['id']);
    setState(() {
      _messageIsError = false;
      _message = 'Removed from favorites.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Favorites'),
      ),
      body: ValueListenableBuilder(
        // READ: everything stored in the box, newest first
        valueListenable: favoritesBox.listenable(),
        builder: (context, Box box, _) {
          final favorites = box.values.toList().reversed.toList();
          final withNotes = favorites
              .where((p) => ((p as Map)['note'] ?? '').toString().isNotEmpty)
              .length;

          return Column(
            children: [
              HeaderPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your saved\nreading',
                      style: AppText.heading(30,
                          color: Colors.white, height: 1.15),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatPill(
                          icon: Icons.bookmark,
                          label: '${favorites.length} saved',
                          highlighted: favorites.isNotEmpty,
                        ),
                        StatPill(
                          icon: Icons.sticky_note_2_outlined,
                          label: '$withNotes with notes',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_message != null)
                StatusBanner(
                  message: _message!,
                  isError: _messageIsError,
                  onClose: () => setState(() => _message = null),
                ),
              Expanded(
                child: favorites.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: EmptyState(
                            icon: Icons.bookmark_border,
                            title: 'No favorites yet',
                            message:
                                'Open a post and choose Save to favorites. It will show up here, and you can add a note to it.',
                            actionLabel: 'Browse posts',
                            onAction: () => Navigator.pop(context),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        itemCount: favorites.length,
                        itemBuilder: (context, i) {
                          final post = favorites[i] as Map;
                          // DELETE by swiping left
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Dismissible(
                                key: ValueKey(post['id']),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: AppColors.danger,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 24),
                                  child: const Icon(Icons.delete_outline,
                                      color: Colors.white, size: 28),
                                ),
                                onDismissed: (_) => _delete(post),
                                child: _FavoriteCard(
                                  post: post,
                                  onEditNote: () => _editNote(post),
                                  onDelete: () => _delete(post),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Map post;
  final VoidCallback onEditNote;
  final VoidCallback onDelete;

  const _FavoriteCard({
    required this.post,
    required this.onEditNote,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final int id = post['id'] as int;
    final author = authorOf(id);
    final note = ((post['note'] ?? '') as String).trim();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 6, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthorBadge(author: author, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Post $id by author $author',
                        style: AppText.ui(12.5,
                            color: AppColors.muted, weight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      HighlightedText(
                        text: capitalize(post['title'] as String),
                        highlighted: true,
                        style: AppText.heading(17.5, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Remove from favorites',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, color: AppColors.muted),
                onPressed: onDelete,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Text(
              capitalize(oneLine(post['body'] as String)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.reading(14.5, color: AppColors.muted, height: 1.45),
            ),
          ),
          const SizedBox(height: 10),
          if (note.isEmpty)
            TextButton.icon(
              onPressed: onEditNote,
              icon: const Icon(Icons.edit_note, size: 20),
              label: const Text('Add a note'),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                decoration: BoxDecoration(
                  color: AppColors.sticky,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My note',
                        style: AppText.ui(12.5, weight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(note, style: AppText.reading(16, height: 1.45)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: onEditNote,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit note'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
