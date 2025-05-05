import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  }

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('km'),
  ];

  Future<void> toggleVoice(
    VoiceEvent event,
    Emitter<VoiceState> emit, {
    required bool enableVoice,
  }) async {
    emit(state.copyWith(enableVoice: enableVoice));
  }

  @override
  VoiceState? fromJson(Map<String, dynamic> json) {
    try {
      final enableVoice = bool.tryParse(json['enableVoice'] as String);
      return VoiceState(enableVoice: enableVoice ?? false);
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
    };
  }
}
