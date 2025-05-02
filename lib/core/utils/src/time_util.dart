abstract class TimeUtil {
  static String formatKhmerTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    // final isMorning = time.hour < 12;

    const khmerHourLabel = 'ម៉ោង';
    // const khmerMinuteLabel = 'នាទី';
    // final period = isMorning ? 'ព្រឹក' : 'ល្ងាច';

    return '$khmerHourLabel $hour : $minute';
  }
}
