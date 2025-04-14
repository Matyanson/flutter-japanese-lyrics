// lib/routes/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:japanese_lyrics_app/components/custom_search_bar.dart';
import 'package:japanese_lyrics_app/components/song_tile.dart';
import 'package:japanese_lyrics_app/models/song.dart';
import 'search_controller.dart'; // Import kontroléru

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Stavové proměnné pro načtená data a indikační stav
  List<Song> searchResults = [];
  bool isLoading = false;

  void _performSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    // Použijeme funkcí z controlleru pro načtení písniček
    final results = await fetchSongs(query);

    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  void _onSongTap(Song song) {
    // Při kliknutí vypíšeme do konzole, později přidáme uložení do knihovny a detail
    print('Vybraná píseň: ${song.title} - ${song.artist}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('検索 - Japanese Lyrics'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            // Předáváme callback onSearch do SearchBar komponenty
            child: CustomSearchBar(
              onSearch: _performSearch,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? const Center(
                        child: Text('Zadejte název písně pro vyhledávání...'),
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final song = searchResults[index];
                          return SongTile(
                            song: song,
                            onTap: () => _onSongTap(song),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
