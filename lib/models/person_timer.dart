enum TimerStatus { running, paused, stopped }

class PersonTimer {
  final String id;
  final String name;
  final double hourlyRate;

  final DateTime? startTime;
  final Duration pausedDuration;
  final int elapsedSeconds;

  final TimerStatus status;

  // calculate total price based on time
  double get totalPrice {
    final totalSeconds = currentElapsedSeconds();
    return (totalSeconds / 3600) * hourlyRate;
  }

  PersonTimer({
    required this.id,
    required this.name,
    required this.hourlyRate,
    this.startTime,
    this.pausedDuration = Duration.zero,
    this.elapsedSeconds = 0,
    this.status = TimerStatus.stopped,
  });

  /// Calculate current total elapsed seconds
  int currentElapsedSeconds() {
    if (status == TimerStatus.running && startTime != null) {
      final now = DateTime.now();
      final runningDuration = now.difference(startTime!);
      return elapsedSeconds +
          runningDuration.inSeconds -
          pausedDuration.inSeconds;
    }
    return elapsedSeconds;
  }

  PersonTimer copyWith({
    String? id,
    String? name,
    double? hourlyRate,
    DateTime? startTime,
    Duration? pausedDuration,
    int? elapsedSeconds,
    TimerStatus? status,
  }) {
    return PersonTimer(
      id: id ?? this.id,
      name: name ?? this.name,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      startTime: startTime ?? this.startTime,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'hourlyRate': hourlyRate,
      'startTime': startTime?.toIso8601String(),
      'pausedDuration': pausedDuration.inSeconds,
      'elapsedSeconds': elapsedSeconds,
      'status': status.index,
    };
  }

  factory PersonTimer.fromJson(Map<String, dynamic> json) {
    return PersonTimer(
      id: json['id'] as String,
      name: json['name'] as String,
      hourlyRate: (json['hourlyRate'] as num).toDouble(),
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      pausedDuration: Duration(seconds: json['pausedDuration'] ?? 0),
      elapsedSeconds: json['elapsedSeconds'] ?? 0,
      status: TimerStatus.values[json['status'] as int],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hourlyRate': hourlyRate,
      'startTime': startTime?.toIso8601String(),
      'pausedDuration': pausedDuration.inSeconds,
      'elapsedSeconds': elapsedSeconds,
      'status': status.index,
    };
  }
}
