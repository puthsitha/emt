import 'package:employee_work/core/enums/enum.dart';
import 'package:employee_work/core/extensions/src/build_context_ext.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:employee_work/models/person_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PersonDetail extends StatelessWidget {
  const PersonDetail({super.key, required this.timer});

  final PersonTimer timer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final totalTime = Duration(seconds: timer.currentElapsedSeconds());
    final price = timer.totalPrice;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(totalTime.inHours);
    final minutes = twoDigits(totalTime.inMinutes.remainder(60));
    final seconds = twoDigits(totalTime.inSeconds.remainder(60));

    return AlertDialog(
      actionsOverflowButtonSpacing: 0,
      backgroundColor: context.colors.neutral100,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
            child: SvgPicture.asset(
              fit: BoxFit.cover,
              height: 370,
              width: double.infinity,
              timer.status == TimerStatus.stopped
                  ? 'assets/svgs/done_working.svg'
                  : timer.status == TimerStatus.paused
                      ? 'assets/svgs/pause_working.svg'
                      : 'assets/svgs/working.svg',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${l10n.status} : ",
                      style: context.textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      switch (timer.status) {
                        TimerStatus.running => l10n.running.toUpperCase(),
                        TimerStatus.paused => l10n.pause.toUpperCase(),
                        TimerStatus.stopped => l10n.stop.toUpperCase(),
                      },
                      style: context.textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: switch (timer.status) {
                            TimerStatus.running => context.colors.orangePrimary,
                            TimerStatus.paused => context.colors.primary,
                            TimerStatus.stopped => context.colors.redPrimary,
                          }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${l10n.total_hours} : ",
                      style: context.textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: context.textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          if (hours != '00')
                            TextSpan(
                              text: '$hours ${l10n.hour}',
                              style: const TextStyle(color: Colors.green),
                            ),
                          if (minutes != '00')
                            TextSpan(
                              text: ' $minutes ${l10n.minute}',
                              style: const TextStyle(color: Colors.blue),
                            ),
                          TextSpan(
                            text: ' $seconds ${l10n.second}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${l10n.total_money} : ",
                      style: context.textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${price.toStringAsFixed(0)} ${l10n.riel}',
                      style: context.textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colors.greenPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
