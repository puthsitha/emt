part of 'voice_bloc.dart';

class VoiceState extends Equatable {
  const VoiceState({
    this.enableVoice = false,
  });

  final bool enableVoice;

  VoiceState copyWith({
    bool? enableVoice,
  }) {
    return VoiceState(
      enableVoice: enableVoice ?? this.enableVoice,
    );
  }

  @override
  List<Object?> get props => [enableVoice];
}
