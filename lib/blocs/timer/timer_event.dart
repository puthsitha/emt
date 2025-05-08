part of 'timer_bloc.dart';

@immutable
sealed class TimerEvent {}

class StartTimer extends TimerEvent {
  final String id;
  final String name;
  final File? image;
  final double hourlyRate;

  StartTimer({
    required this.id,
    required this.name,
    required this.hourlyRate,
    this.image,
  });
}

class PauseTimer extends TimerEvent {
  final String id;

  PauseTimer(this.id);
}

class ResumeTimer extends TimerEvent {
  final String id;

  ResumeTimer(this.id);
}

class StopTimer extends TimerEvent {
  final String id;

  StopTimer(this.id);
}

class DeleteTimer extends TimerEvent {
  final String id;

  DeleteTimer(this.id);
}

class Tick extends TimerEvent {}

class ResetTimer extends TimerEvent {
  final String id;

  ResetTimer(this.id);
}

class ResetAllTimers extends TimerEvent {}

class StopAllTimers extends TimerEvent {}

class PauseAllTimers extends TimerEvent {}

class ResumeAllTimers extends TimerEvent {}

class ReStartAllTimers extends TimerEvent {}
