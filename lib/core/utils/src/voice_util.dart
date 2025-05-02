import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

abstract class VoiceUtil {
  static Future<void> speakText(String text) async {
    final FlutterTts flutterTts = FlutterTts();

    await flutterTts.setLanguage("km-KH"); // or "km-KH" for Khmer
    await flutterTts.setSpeechRate(0.5); // optional: 0.0 to 1.0
    await flutterTts.setVolume(1);
    // await flutterTts.setVoice({"name": "km-kh-x-khm-local", "locale": "km-KH"});
    // await flutterTts
    //     .setVoice({"name": "km-kh-x-khm-network", "locale": "km-KH"});
    await flutterTts.speak(text);
  }

  static Future<void> alertSound(String sound) async {
    final AudioPlayer audioPlayer = AudioPlayer();
    await audioPlayer.play(AssetSource(sound));
  }
}
