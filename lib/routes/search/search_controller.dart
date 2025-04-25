// lib/routes/search/search_controller.dart
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:japanese_lyrics_app/constants/api_base_url.dart';

import '../../models/song.dart';

/// vyhledání písní podle keyword z API
Future<List<Song>> fetchSongs(String query) async {

  final encodedQuery = Uri.encodeComponent(query);
  final url = '$apiBaseUrl/search?query=$encodedQuery';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load search results');
    }

    // parse and save results
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> jsonData = data['results'];
    final songs = jsonData.map((json) => Song(
      title: json['title'],
      artist: json['artist'],
      lyrics: [], // lyrics budou fetchnuty až při kliknutí
      url: json['url'],
    )).toList();
    
    return songs;
    
  } catch (e) {
    print('Error fetching search results: $e');
    rethrow;
  }
}

/// vyhledání lyrics písně z API podle url
Future<List<String>> fetchLyrics(String songUrl) async {
  final encodedSongUrl = Uri.encodeComponent(songUrl);
  final url = '$apiBaseUrl/lyrics?url=$encodedSongUrl';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load search results');
    }

    // parse and save results
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<String> lyrics = List<String>.from(data['lyrics']);    
    return lyrics;
    
  } catch (e) {
    print('Error fetching lyrics: $e');
    rethrow;
  }
}