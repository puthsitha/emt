import 'dart:async';
import 'package:employee_work/models/person_timer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends HydratedBloc<TimerEvent, TimerState> {
  TimerBloc() : super(const TimerState()) {
    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<ResumeTimer>(_onResumeTimer);
    on<StopTimer>(_onStopTimer);
    on<DeleteTimer>(_onDeleteTimer);
    on<Tick>(_onTick);

    // Start the ticking
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      print('Ticking...');
      add(Tick());
    });
  }

  late final Timer _ticker;

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    final newTimer = PersonTimer(
      id: event.id,
      name: event.name,
      hourlyRate: event.hourlyRate,
      startTime: DateTime.now(),
      status: TimerStatus.running,
    );

    emit(state.copyWith(
      timers: [...state.timers, newTimer],
    ));
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    final updatedTimers = state.timers.map((timer) {
      if (timer.id == event.id &&
          timer.status == TimerStatus.running &&
          timer.startTime != null) {
        final now = DateTime.now();
        final runningDuration = now.difference(timer.startTime!);

        return timer.copyWith(
          elapsedSeconds: timer.elapsedSeconds +
              runningDuration.inSeconds -
              timer.pausedDuration.inSeconds,
          pausedDuration: Duration.zero,
          startTime: null,
          status: TimerStatus.paused,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _onResumeTimer(ResumeTimer event, Emitter<TimerState> emit) {
    final updatedTimers = state.timers.map((timer) {
      if (timer.id == event.id && timer.status == TimerStatus.paused) {
        return timer.copyWith(
          startTime: DateTime.now(),
          pausedDuration: Duration.zero,
          status: TimerStatus.running,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _onStopTimer(StopTimer event, Emitter<TimerState> emit) {
    final updatedTimers = state.timers.map((timer) {
      if (timer.id == event.id && timer.status != TimerStatus.stopped) {
        int totalElapsed = timer.elapsedSeconds;

        if (timer.startTime != null) {
          final now = DateTime.now();
          final runningDuration = now.difference(timer.startTime!);
          totalElapsed +=
              runningDuration.inSeconds - timer.pausedDuration.inSeconds;
        }

        return timer.copyWith(
          elapsedSeconds: totalElapsed,
          startTime: null,
          pausedDuration: Duration.zero,
          status: TimerStatus.stopped,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _onDeleteTimer(DeleteTimer event, Emitter<TimerState> emit) {
    final updatedTimers =
        state.timers.where((timer) => timer.id != event.id).toList();
    emit(state.copyWith(timers: updatedTimers));
  }

  void _onTick(Tick event, Emitter<TimerState> emit) {
    // We just re-emit to trigger UI updates based on DateTime.now()
    // emit(state.copyWith(timers: [...state.timers]));
    final updatedTimers = state.timers.map((timer) {
      if (timer.status == TimerStatus.running) {
        return timer
            .copyWith(); // This returns a new instance even if unchanged
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  @override
  TimerState fromJson(Map<String, dynamic> json) {
    try {
      final timers = (json['timers'] as List<dynamic>)
          .map((e) => PersonTimer.fromJson(e as Map<String, dynamic>))
          .toList();
      return TimerState(timers: timers);
    } catch (_) {
      return const TimerState();
    }
  }

  @override
  Map<String, dynamic> toJson(TimerState state) {
    return {
      'timers': state.timers.map((e) => e.toJson()).toList(),
    };
  }

  @override
  Future<void> close() {
    _ticker.cancel();
    return super.close();
  }
}
