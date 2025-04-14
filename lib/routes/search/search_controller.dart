// lib/routes/search/search_controller.dart
import '../../models/song.dart';

/// Funkce simuluje načítání dat z API (zatím vrací mockup data).
Future<List<Song>> fetchSongs(String query) async {
  // Simulace latence (např. volání API)
  await Future.delayed(const Duration(seconds: 1));
  
  // Návrat statických dat – později bude nahrazeno voláním Musicmatch API.
  return [
    Song(
      title: 'Song A',
      artist: 'Artist A',
      lyrics: ['Řádek 1', 'Řádek 2', 'Řádek 3'],
    ),
    Song(
      title: 'Song B',
      artist: 'Artist B',
      lyrics: ['Verš A', 'Verš B'],
    ),
    Song(
      title: 'Song C',
      artist: 'Artist C',
      lyrics: ['První verš', 'Druhý verš'],
    ),
  ];
}