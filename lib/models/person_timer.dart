import 'dart:io';

import 'package:employee_work/core/enums/enum.dart';

class PersonTimer {
  final String id;
  final String name;
  final File? image;
  final num hourlyRate;

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
    this.image,
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
    File? image,
    num? hourlyRate,
    DateTime? startTime,
    Duration? pausedDuration,
    int? elapsedSeconds,
    TimerStatus? status,
  }) {
    return PersonTimer(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      startTime: startTime ?? this.startTime,
      pausedDuration: pausedDuration ?? this.pausedDuration,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toParamater() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': image?.path,
      'hourlyRate': hourlyRate.toString(),
    };
  }

  factory PersonTimer.fromParamater(Map<String, dynamic> json) {
    File? imageFile;
    if (json['image'] != null && json['image'] != '') {
      final file = File(json['image']);
      if (file.existsSync()) {
        imageFile = file;
      }
    }

    return PersonTimer(
      id: json['id'] as String,
      name: json['name'] as String,
      image: imageFile,
      hourlyRate: num.parse(json['hourlyRate'] as String),
    );
  }

  factory PersonTimer.fromJson(Map<String, dynamic> json) {
    File? imageFile;
    if (json['image'] != null && json['image'] != '') {
      final file = File(json['image']);
      if (file.existsSync()) {
        imageFile = file;
      }
    }

    return PersonTimer(
      id: json['id'] as String,
      name: json['name'] as String,
      image: imageFile,
      hourlyRate: json['hourlyRate'],
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
      'image': image?.path, // Save only the path
      'hourlyRate': hourlyRate,
      'startTime': startTime?.toIso8601String(),
      'pausedDuration': pausedDuration.inSeconds,
      'elapsedSeconds': elapsedSeconds,
      'status': status.index,
    };
  }
}
