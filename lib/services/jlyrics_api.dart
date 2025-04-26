import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:japanese_lyrics_app/constants/api_base_url.dart';
import 'package:japanese_lyrics_app/models/song.dart';

/// vyhledání písní podle keyword z API
Future<List<Song>> fetchSongs(String query) async {

  final encodedQuery = Uri.encodeComponent(query);
  final url = '$apiBaseUrl/search?query=$encodedQuery';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    // parse and save results
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> jsonSongs = data['results'];
    final songs = jsonSongs.map((songData) => Song(
      title: songData['title'],
      artist: songData['artist'],
      lyrics: [], // lyrics budou fetchnuty až při kliknutí
      url: songData['url'],
    )).toList();
    
    return songs;
    
  } catch (e) {
    throw Exception('Failed to fetch songs: $e');
  }
}

/// vyhledání lyrics písně z API podle url
Future<List<String>> fetchLyrics(String songUrl) async {
  final encodedSongUrl = Uri.encodeComponent(songUrl);
  final url = '$apiBaseUrl/lyrics?url=$encodedSongUrl';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    // parse the lyrics
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<String> lyrics = List<String>.from(data['lyrics']);
    
    return lyrics;
  } catch (e) {
    throw Exception('Failed to fetch lyrics: $e');
  }
}