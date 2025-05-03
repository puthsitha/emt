import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

abstract class VoiceUtil {
  static Future<void> speakText(
    String text, {
    void Function()? grantedCallback,
  }) async {
    final FlutterTts flutterTts = FlutterTts();
    final isSupportKhmer = await flutterTts.isLanguageInstalled("km-KH");
    if (isSupportKhmer) {
      await flutterTts.setLanguage("km-KH");
      await flutterTts.setVoice({"name": "km-KH-language", "locale": "km-KH"});
    } else {
      if (grantedCallback != null) {
        grantedCallback();
      }
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVoice({"name": "en-US-language", "locale": "en-US"});
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
