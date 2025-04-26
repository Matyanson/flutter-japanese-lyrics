import 'package:hive/hive.dart';
import '../models/song.dart';

class HiveRepository {
  static const String boxName = 'library';

  Box<Song> getLibraryBox() {
    return Hive.box<Song>(boxName);
  }

  /// Přidá píseň do knihovny.
  Future<void> addSong(Song song) async {
    final box = getLibraryBox();
    await box.put(song.id, song);
  }

  /// Vrátí všechny uložené písně.
  List<Song> getAllSongs() {
    final box = getLibraryBox();
    return box.values.toList();
  }
}
