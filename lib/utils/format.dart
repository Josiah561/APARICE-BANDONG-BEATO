/// Upper-cases the first letter (JSONPlaceholder text is all lowercase).
String capitalize(String text) {
  final t = text.trim();
  if (t.isEmpty) return t;
  return t[0].toUpperCase() + t.substring(1);
}

/// Collapses line breaks so a preview can sit on one or two lines.
String oneLine(String text) => text.replaceAll('\n', ' ');

/// Estimated reading time in minutes (200 words per minute, minimum 1).
int readingMinutes(String text) {
  final words = text.trim().split(RegExp(r'\s+')).length;
  final minutes = (words / 200).ceil();
  return minutes < 1 ? 1 : minutes;
}

/// JSONPlaceholder gives each author 10 posts, so the author number
/// can be worked out from the post id (1-10 -> author 1, 11-20 -> author 2...).
int authorOf(int postId) => ((postId - 1) ~/ 10) % 10 + 1;
