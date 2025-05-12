import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'voice_event.dart';
part 'voice_state.dart';

class VoiceBloc extends HydratedBloc<VoiceEvent, VoiceState> {
  VoiceBloc() : super(const VoiceState()) {
    on<VoiceAllow>(
      (event, emit) => toggleVoice(
        event,
        emit,
        enableVoice: event.enableVoice,
      ),
    );
    on<VoiceAIAllow>(
      (event, emit) => toggleAIVoice(
        event,
        emit,
        allow: event.allow,
      ),
    );
  }

  Future<void> toggleVoice(
    VoiceEvent event,
    Emitter<VoiceState> emit, {
    required bool enableVoice,
  }) async {
    emit(state.copyWith(enableVoice: enableVoice));
  }

  Future<void> toggleAIVoice(
    VoiceEvent event,
    Emitter<VoiceState> emit, {
    required bool allow,
  }) async {
    emit(state.copyWith(allowAIvoie: allow));
  }

  @override
  VoiceState? fromJson(Map<String, dynamic> json) {
    try {
      final enableVoice = bool.tryParse(json['enableVoice'] as String);
      final allowAIvoie = bool.tryParse(json['allowAIVoice'] as String);
      return VoiceState(
        enableVoice: enableVoice ?? false,
        allowAIvoie: allowAIvoie ?? false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error deserializing state: $e');
      }
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(VoiceState state) {
    return {
      'enableVoice': state.enableVoice.toString(),
      'allowAIVoice': state.allowAIvoie.toString(),
    };
  }
}
