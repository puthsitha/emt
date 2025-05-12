part of 'voice_bloc.dart';

@immutable
sealed class VoiceEvent {}

class VoiceAllow extends VoiceEvent {
  VoiceAllow({
    required this.enableVoice,
  });
  final bool enableVoice;
}

class VoiceAIAllow extends VoiceEvent {
  VoiceAIAllow({
    required this.allow,
  });
  final bool allow;
}
