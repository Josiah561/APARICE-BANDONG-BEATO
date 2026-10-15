import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../boxes.dart';
import '../constants.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/add_post_dialog.dart';
import '../widgets/author_chips.dart';
import '../widgets/empty_state.dart';
import '../widgets/favorites_button.dart';
import '../widgets/header_panel.dart';
import '../widgets/post_card.dart';
import '../widgets/skeleton_card.dart';
import '../widgets/stat_pill.dart';
import '../widgets/status_banner.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _searchController = TextEditingController();

  List<dynamic> _posts = [];
  bool _isLoading = true;
  String? _errorMessage; // GET error
  String? _statusMessage; // POST result
  bool _statusIsError = false;
  String _query = '';
  int? _authorFilter;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // GET request
  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        setState(() => _posts = data);
      } else {
        setState(() => _errorMessage =
            'The server answered with status ${response.statusCode}. '
            'Try again in a moment.');
      }
    } catch (e) {
      setState(() => _errorMessage =
          'No response from the server. Check your internet connection '
          'and try again.\n\nDetails: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // POST request
  Future<void> _sendPost(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'title': title, 'body': body, 'userId': 1}),
      );
      setState(() {
        if (response.statusCode == 201) {
          _statusIsError = false;
          _statusMessage = 'Post sent (status 201). JSONPlaceholder only '
              'simulates saving, so it will not appear in the list.';
        } else {
          _statusIsError = true;
          _statusMessage =
              'Post not sent. The server answered with status ${response.statusCode}.';
        }
      });
    } catch (e) {
      setState(() {
        _statusIsError = true;
        _statusMessage = 'Post not sent. Check your connection and try again.';
      });
    }
  }

  Future<void> _openAddDialog() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const AddPostDialog(),
    );
    if (result != null) {
      await _sendPost(result['title']!, result['body']!);
    }
  }

  Future<void> _openDetails(Map post) async {
    await Navigator.pushNamed(
      context,
      '/details',
      arguments: {
        'id': post['id'],
        'title': post['title'],
        'body': post['body'],
      },
    );
    // Refresh so saved markers reflect changes made on the details screen.
    if (mounted) setState(() {});
  }

  Future<void> _openFavorites() async {
    await Navigator.pushNamed(context, '/favorites');
    if (mounted) setState(() {});
  }

  List<dynamic> get _filteredPosts {
    final q = _query.trim().toLowerCase();
    return _posts.where((p) {
      final post = p as Map;
      if (_authorFilter != null &&
          authorOf(post['id'] as int) != _authorFilter) {
        return false;
      }
      if (q.isEmpty) return true;
      return (post['title'] as String).toLowerCase().contains(q) ||
          (post['body'] as String).toLowerCase().contains(q);
    }).toList();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _authorFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Reader & Favorites'),
        actions: [FavoritesButton(onPressed: _openFavorites)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        icon: const Icon(Icons.edit_outlined),
        label: const Text('New post'),
      ),
      body: Column(
        children: [
          _buildHeader(),
          if (_statusMessage != null)
            StatusBanner(
              message: _statusMessage!,
              isError: _statusIsError,
              onClose: () => setState(() => _statusMessage = null),
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return HeaderPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What will you\nread today?',
            style: AppText.heading(30, color: Colors.white, height: 1.15),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            style: AppText.ui(15.5, color: Colors.white),
            cursorColor: AppColors.marker,
            decoration: InputDecoration(
              hintText: 'Search titles and text',
              hintStyle: AppText.ui(15.5, color: Colors.white60),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    ),
              filled: true,
              fillColor: Colors.white.withAlpha(30),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.marker, width: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 14),
          ValueListenableBuilder(
            valueListenable: favoritesBox.listenable(),
            builder: (context, Box box, _) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatPill(
                  icon: Icons.article_outlined,
                  label: _isLoading ? 'Loading' : '${_posts.length} posts',
                ),
                StatPill(
                  icon: Icons.bookmark_border,
                  label: '${box.length} saved',
                  highlighted: box.isNotEmpty,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return ListView(
        padding: const EdgeInsets.only(top: 12),
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          SkeletonCard(),
          SkeletonCard(),
          SkeletonCard(),
          SkeletonCard(),
        ],
      );
    }
    if (_errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.cloud_off_outlined,
            title: 'Posts could not be loaded',
            message: _errorMessage!,
            actionLabel: 'Try again',
            onAction: _fetchPosts,
          ),
        ),
      );
    }

    final posts = _filteredPosts;
    return Column(
      children: [
        AuthorChips(
          selected: _authorFilter,
          onSelected: (author) => setState(() => _authorFilter = author),
        ),
        Expanded(
          child: posts.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    child: EmptyState(
                      icon: Icons.search_off,
                      title: 'No matching posts',
                      message:
                          'Nothing matches your search. Try different words or clear the filters.',
                      actionLabel: 'Clear filters',
                      onAction: _clearFilters,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 96),
                  itemCount: posts.length,
                  itemBuilder: (context, i) {
                    final post = posts[i] as Map;
                    return PostCard(
                      post: post,
                      isSaved: favoritesBox.containsKey(post['id']),
                      onTap: () => _openDetails(post),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
