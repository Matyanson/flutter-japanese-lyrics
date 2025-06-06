import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:japanese_lyrics_app/constants/url.dart';

class VoiceVoxService {
  final int speakerId;
  final _player = AudioPlayer();

  VoiceVoxService({
    this.speakerId = 3, // Zundamon is usually speakerId 3
  });

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    try {
      // Step 1: audio_query
      final audioQueryRes = await http.post(
        Uri.parse('$voicevoxBaseUrl/audio_query?speaker=$speakerId&text=$text'),
        headers: {'Content-Type': 'application/json'},
      );

      if (audioQueryRes.statusCode != 200) {
        throw Exception('Failed to create audio_query');
      }

      final audioQuery = audioQueryRes.body;

      // Step 2: synthesis
      final synthRes = await http.post(
        Uri.parse('$voicevoxBaseUrl/synthesis?speaker=$speakerId'),
        headers: {'Content-Type': 'application/json'},
        body: audioQuery,
      );

      if (synthRes.statusCode != 200) {
        throw Exception('Failed to synthesize audio');
      }

      final wavBytes = synthRes.bodyBytes;

      // Step 3: play audio
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse('data:audio/wav;base64,${base64Encode(wavBytes)}')),
      );

      
      print('speak: $text');


      await _player.play();
    } catch (e) {
      print('VoiceVox Error: $e');
    }
  }
}