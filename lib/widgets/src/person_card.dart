import 'package:employee_work/blocs/lang/language_bloc.dart';
import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/blocs/voice/voice_bloc.dart';
import 'package:employee_work/core/common/common.dart';
import 'package:employee_work/core/enums/enum.dart';
import 'package:employee_work/core/extensions/extension.dart';
import 'package:employee_work/core/routes/routes.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/core/utils/util.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:employee_work/models/person_timer.dart';
import 'package:employee_work/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class PersonCard extends StatelessWidget {
  const PersonCard({super.key, required this.timer});

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

    return Slidable(
      key: ValueKey(
        timer.id,
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        closeThreshold: 0.1,
        extentRatio: 0.4,
        openThreshold: 0.1,
        key: ValueKey(timer.id),
        children: [
          SlidableAction(
            onPressed: (_) {
              _showDeletePersonDialog(context, id: timer.id);
            },
            padding: EdgeInsets.zero,
            spacing: 0,
            backgroundColor: context.colors.redPrimary,
            foregroundColor: Colors.white,
            label: l10n.delete,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              topLeft: Radius.circular(6),
            ),
            icon: Icons.delete,
          ),
          SlidableAction(
            onPressed: (_) {
              context.pushNamed(
                Pages.employeeForm.name,
                queryParameters: timer.toParamater(),
              );
            },
            padding: EdgeInsets.zero,
            spacing: 2,
            backgroundColor: context.colors.primary,
            foregroundColor: Colors.white,
            label: l10n.update,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            icon: Icons.edit_note_sharp,
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        child: ListTile(
          onLongPress: () => timer.status != TimerStatus.running
              ? _showPersonDetailDialog(context, timer: timer)
              : null,
          title: Row(
            children: [
              if (timer.image != null)
                CircleAvatar(
                  radius: 35,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipOval(
                      child: Image.file(
                        timer.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else
                BlocBuilder<LanguageBloc, LanguageState>(
                  builder: (context, langState) {
                    return CircleAvatar(
                      radius: 35,
                      backgroundColor: getAvatarColor(timer.name),
                      child: Text(
                        timer.name.substring(
                            0,
                            langState.selectLanguage == const Locale('en')
                                ? 2
                                : 3),
                        style: context.textTheme.titleMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(width: Spacing.s),
              Text(
                timer.name,
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Spacing.s),
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 20,
                    color: context.colors.greyDark,
                  ),
                  const SizedBox(width: Spacing.s),
                  RichText(
                    text: TextSpan(
                      style: context.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
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
              const SizedBox(width: Spacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    size: 20,
                    color: context.colors.greenPrimary,
                  ),
                  const SizedBox(width: Spacing.s),
                  Text(
                    '${price.toStringAsFixed(0)} ${l10n.riel}',
                    style: context.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.sports_gymnastics_outlined,
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: Spacing.s),
                  Text(
                    switch (timer.status) {
                      TimerStatus.running => l10n.running.toUpperCase(),
                      TimerStatus.paused => l10n.pause.toUpperCase(),
                      TimerStatus.stopped => l10n.stop.toUpperCase(),
                    },
                    style: context.textTheme.titleMedium!.copyWith(
                      color: timer.status == TimerStatus.running
                          ? context.colors.orangePrimary
                          : timer.status == TimerStatus.paused
                              ? context.colors.primary
                              : context.colors.redPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: Spacing.sm),
              Row(
                children: [
                  const Icon(
                    Icons.start,
                    size: 20,
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(width: Spacing.s),
                  RichText(
                    text: TextSpan(
                      style: context.textTheme.titleMedium,
                      children: [
                        if (timer.startTimeText != null) ...[
                          TextSpan(
                            text: '${timer.startTimeText.toString()} ',
                          ),
                          TextSpan(
                            text: '(${l10n.start_timer})',
                            style: context.textTheme.titleMedium!.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ] else
                          const TextSpan(
                            text: 'N/A',
                          ),
                      ],
                    ),
                  )
                ],
              ),
              if (timer.status == TimerStatus.stopped) ...[
                const SizedBox(width: Spacing.sm),
                Row(
                  children: [
                    const Icon(
                      Icons.stop_rounded,
                      size: 20,
                      color: Colors.deepOrangeAccent,
                    ),
                    const SizedBox(width: Spacing.s),
                    RichText(
                      text: TextSpan(
                        style: context.textTheme.titleMedium, // base style
                        children: [
                          TextSpan(
                            text: timer.endTimeText != null
                                ? '${timer.endTimeText.toString()} '
                                : 'N/A',
                            style: context.textTheme.titleMedium,
                          ),
                          if (timer.endTimeText != null)
                            TextSpan(
                              text: '(${l10n.stop_timer})',
                              style: context.textTheme.titleMedium!.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
              const SizedBox(width: Spacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.hourglass_bottom_rounded,
                    size: 20,
                    color: context.colors.purplePrimary,
                  ),
                  const SizedBox(width: Spacing.s),
                  Text(
                    '${timer.hourlyRate.toStringAsFixed(0)} (${l10n.riels_hour})',
                    style: context.textTheme.titleMedium!.copyWith(),
                  ),
                ],
              ),
            ],
          ),
          trailing: BlocBuilder<VoiceBloc, VoiceState>(
            builder: (context, voiceState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (timer.status == TimerStatus.running)
                    IconButton(
                      icon: Icon(
                        Icons.pause,
                        color: context.colors.orangePrimary,
                      ),
                      onPressed: () {
                        if (voiceState.enableVoice) {
                          VoiceUtil.speakText(
                            voice: 'sounds/pause.mp3',
                            '${timer.name}${'សម្រាកធ្វើការ'}${TimeUtil.formatKhmerTime(DateTime.now())}',
                            allowAIVoice: voiceState.allowAIvoie,
                          );
                        }
                        context.read<TimerBloc>().add(PauseTimer(timer.id));
                      },
                    )
                  else if (timer.status == TimerStatus.paused)
                    IconButton(
                      icon:
                          Icon(Icons.play_arrow, color: context.colors.primary),
                      onPressed: () {
                        if (voiceState.enableVoice) {
                          VoiceUtil.speakText(
                            voice: 'sounds/resume.mp3',
                            '${timer.name}${'បន្តធ្វើការ'}${TimeUtil.formatKhmerTime(DateTime.now())}',
                            allowAIVoice: voiceState.allowAIvoie,
                          );
                        }
                        context.read<TimerBloc>().add(ResumeTimer(timer.id));
                      },
                    ),
                  if (timer.status != TimerStatus.stopped)
                    IconButton(
                      icon: Icon(Icons.stop, color: context.colors.redPrimary),
                      onPressed: () {
                        if (voiceState.enableVoice) {
                          VoiceUtil.speakText(
                            voice: 'sounds/stop.mp3',
                            '${timer.name}${'ឈប់ធ្វើការ'}${TimeUtil.formatKhmerTime(DateTime.now())}',
                            allowAIVoice: voiceState.allowAIvoie,
                          );
                        }
                        context.read<TimerBloc>().add(StopTimer(timer.id));
                      },
                    )
                  else if (timer.totalPrice != 0.0)
                    IconButton(
                      icon: Icon(Icons.restart_alt,
                          color: context.colors.purplePrimary),
                      onPressed: () {
                        context.read<TimerBloc>().add(ResetTimer(timer.id));
                      },
                    ),
                  if (timer.totalPrice == 0.0 &&
                      timer.status != TimerStatus.running &&
                      timer.status != TimerStatus.paused)
                    IconButton(
                      icon:
                          Icon(Icons.start, color: context.colors.greenPrimary),
                      onPressed: () {
                        if (voiceState.enableVoice) {
                          VoiceUtil.speakText(
                            voice: 'sounds/restart.mp3',
                            '${timer.name}${'ចាប់ផ្តើមធ្វើការ'}${TimeUtil.formatKhmerTime(DateTime.now())}',
                            allowAIVoice: voiceState.allowAIvoie,
                          );
                        }
                        context.read<TimerBloc>().add(ResumeTimer(timer.id));
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showDeletePersonDialog(BuildContext context, {required String id}) {
    showDialog(
        context: context,
        builder: (_) => DeletePerson(
              context: context,
              id: id,
            ));
  }

  void _showPersonDetailDialog(BuildContext context,
      {required PersonTimer timer}) {
    showDialog(
        context: context,
        builder: (_) => PersonDetail(
              timer: timer,
            ));
  }
}
