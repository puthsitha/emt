import 'dart:async';
import 'package:employee_work/core/enums/enum.dart';
import 'package:employee_work/models/person_timer.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
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
    on<ResetTimer>(_resetTimer);
    on<ResetAllTimers>(_resetAllTimer);
    on<StopAllTimers>(_stopAllTimers);
    on<PauseAllTimers>(_pauseAllTimers);
    on<ResumeAllTimers>(_resumeAllTimers);
    on<ReStartAllTimers>(_reStartAllTimers);

    // Start the ticking
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (kDebugMode) {}
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
      timers: [newTimer, ...state.timers],
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
      if (timer.id == event.id &&
          (timer.status == TimerStatus.paused ||
              timer.status == TimerStatus.stopped)) {
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

  void _resetTimer(ResetTimer event, Emitter<TimerState> emit) {
    final updatedTimers = state.timers.map((timer) {
      if (timer.id == event.id) {
        return timer.copyWith(
          startTime: null,
          pausedDuration: Duration.zero,
          elapsedSeconds: 0,
          status: TimerStatus.stopped,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _resetAllTimer(ResetAllTimers event, Emitter<TimerState> emit) {
    final resetTimers = state.timers.map((timer) {
      return timer.copyWith(
        startTime: null,
        pausedDuration: Duration.zero,
        elapsedSeconds: 0,
        status: TimerStatus.stopped,
      );
    }).toList();

    emit(state.copyWith(timers: resetTimers));
  }

  void _stopAllTimers(StopAllTimers event, Emitter<TimerState> emit) {
    final updatedTimers = state.timers.map((timer) {
      if (timer.status == TimerStatus.running ||
          timer.status == TimerStatus.paused) {
        final elapsed = timer.currentElapsedSeconds();

        return timer.copyWith(
          status: TimerStatus.stopped,
          elapsedSeconds: elapsed,
          startTime: null,
          pausedDuration: Duration.zero,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _pauseAllTimers(PauseAllTimers event, Emitter<TimerState> emit) {
    final updatedTimers = state.timers.map((timer) {
      if (timer.status == TimerStatus.running) {
        final elapsed = timer.currentElapsedSeconds();

        return timer.copyWith(
          status: TimerStatus.paused,
          elapsedSeconds: elapsed,
          startTime: null,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _resumeAllTimers(ResumeAllTimers event, Emitter<TimerState> emit) {
    final now = DateTime.now();

    final updatedTimers = state.timers.map((timer) {
      if (timer.status == TimerStatus.paused) {
        return timer.copyWith(
          status: TimerStatus.running,
          startTime: now,
        );
      }
      return timer;
    }).toList();

    emit(state.copyWith(timers: updatedTimers));
  }

  void _reStartAllTimers(ReStartAllTimers event, Emitter<TimerState> emit) {
    final now = DateTime.now();

    final startedTimers = state.timers.map((timer) {
      return timer.copyWith(
        startTime: now,
        pausedDuration: Duration.zero,
        elapsedSeconds: 0,
        status: TimerStatus.running,
      );
    }).toList();

    emit(state.copyWith(timers: startedTimers));
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
