import 'package:hive/hive.dart';
import 'package:japanese_lyrics_app/models/song.dart';

Future<Song?> fetchSongById(int index) async {
  final box = Hive.box<Song>('library');
  if (index < 0 || index >= box.length) return null;
  return box.getAt(index);
}
