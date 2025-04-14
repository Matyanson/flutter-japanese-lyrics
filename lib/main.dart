import 'package:flutter/material.dart';
import 'routes/search/search_screen.dart';

void main() {
  runApp(const JapLyricsApp());
}

class JapLyricsApp extends StatelessWidget {
  const JapLyricsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Japanese Lyrics App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SearchScreen(),
    );
  }
}
