import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

abstract class VoiceUtil {
  static Future<void> speakText(
    String text, {
    required String voice,
    allowAIVoice = false,
  }) async {
    if (!allowAIVoice) {
      alertSound(voice);
      return;
    }
    final FlutterTts flutterTts = FlutterTts();
    final isSupportKhmer = await flutterTts.isLanguageAvailable("km-KH");
    if (isSupportKhmer) {
      await flutterTts.setLanguage("km-KH");
      await flutterTts.setVoice({"name": "km-KH-language", "locale": "km-KH"});
    } else {
      alertSound(voice);
      return;
    }
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1);
    await flutterTts.speak(text);
  }

  static Future<void> alertSound(String sound) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource(sound));
  }
}
