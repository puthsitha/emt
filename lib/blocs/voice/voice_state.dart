part of 'voice_bloc.dart';

class VoiceState extends Equatable {
  const VoiceState({
    this.enableVoice = false,
    this.allowAIvoie = false,
  });

  final bool enableVoice;
  final bool allowAIvoie;

  VoiceState copyWith({
    bool? enableVoice,
    bool? allowAIvoie,
  }) {
    return VoiceState(
      enableVoice: enableVoice ?? this.enableVoice,
      allowAIvoie: allowAIvoie ?? this.allowAIvoie,
    );
  }

  @override
  List<Object?> get props => [enableVoice, allowAIvoie];
}
