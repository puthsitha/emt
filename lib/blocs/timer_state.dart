part of 'timer_bloc.dart';

class TimerState extends Equatable {
  final List<PersonTimer> timers;

  const TimerState({this.timers = const []});

  TimerState copyWith({List<PersonTimer>? timers}) {
    return TimerState(timers: timers ?? this.timers);
  }

  @override
  List<Object?> get props => [timers];
}
