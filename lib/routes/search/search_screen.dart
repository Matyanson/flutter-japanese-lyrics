import 'package:flutter/material.dart';
import 'package:japanese_lyrics_app/components/custom_search_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索 - Japanese Lyrics'),
      ),
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: CustomSearchBar(),
          ),
          Expanded(
            child: Center(
              child: Text('Zadejte název písně pro vyhledávání...'),
            ),
          ),
        ],
      ),
    );
  }
}
