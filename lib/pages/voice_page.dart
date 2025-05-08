import 'package:employee_work/core/extensions/src/build_context_ext.dart';
import 'package:employee_work/core/theme/colors.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

class VoicePage extends StatelessWidget {
  const VoicePage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
        child: VoicePage(key: key),
      );

  @override
  Widget build(BuildContext context) {
    return const VoiceView();
  }
}

class VoiceView extends StatefulWidget {
  const VoiceView({super.key});

  @override
  State<VoiceView> createState() => _VoiceViewState();
}

class _VoiceViewState extends State<VoiceView> {
  FlutterTts flutterTts = FlutterTts();
  List<dynamic> _voices = [];

  @override
  void initState() {
    super.initState();
    _getVoices();
  }

  Future<void> _getVoices() async {
    _voices = await flutterTts.getVoices;
    setState(() {});
  }

  Future<void> _speakWithVoice(dynamic voice) async {
    final voiceName = voice['name'];
    final voiceLocal = voice['locale'];
    await flutterTts.setLanguage(voiceLocal);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1);
    await flutterTts.setVoice({"name": voiceName, "locale": voiceLocal});
    await flutterTts.speak("សួស្តី នេះជារបៀបដែលខ្ញុំនិយាយ");
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.voice,
          style: context.textTheme.displayMedium!.copyWith(
            color: AppColors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
          ),
        ),
        backgroundColor: context.colors.primary,
      ),
      body: _voices.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _voices.length,
              itemBuilder: (context, index) {
                final voice = _voices[index];
                return ListTile(
                  title: Text(voice['name'] ?? 'Unknown'),
                  subtitle: Text(voice['locale'] ?? 'Unknown locale'),
                  onTap: () {
                    _speakWithVoice(voice);
                  },
                );
              },
            ),
    );
  }
}
