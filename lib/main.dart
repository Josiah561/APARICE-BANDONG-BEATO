import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'boxes.dart';
import 'constants.dart';
import 'screens/favorites_screen.dart';
import 'screens/post_details_screen.dart';
import 'screens/posts_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  favoritesBox = await Hive.openBox(favoritesBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post Reader & Favorites',
      theme: AppTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const PostsScreen(),
        '/details': (context) => const PostDetailsScreen(),
        '/favorites': (context) => const FavoritesScreen(),
      },
    );
  }
}
