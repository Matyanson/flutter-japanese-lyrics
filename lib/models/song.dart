import 'package:hive/hive.dart';

part 'song.g.dart'; // Tento soubor se vygeneruje pomocí build_runner

@HiveType(typeId: 0)
class Song {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String artist;

  @HiveField(3)
  List<String> lyrics;

  @HiveField(4)
  final String url;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.url
  });

  Song copyWithDetails(List<String> lyrics) {
    return Song(id: id, title: title, artist: artist, lyrics: lyrics, url: url);
  }
}
