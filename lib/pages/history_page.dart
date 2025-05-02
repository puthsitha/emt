import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/core/common/common.dart';
import 'package:employee_work/core/enums/enum.dart';
import 'package:employee_work/core/extensions/extension.dart';
import 'package:employee_work/core/theme/colors.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:employee_work/models/person_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
        child: HistoryPage(key: key),
      );

  @override
  Widget build(BuildContext context) {
    return const HistoryView();
  }
}

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.history,
          style: context.textTheme.headlineLarge!.copyWith(
            color: AppColors.white,
          ),
        ),
        backgroundColor: context.colors.primary,
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final finishedTimers = state.timers
              .where((timer) => timer.status == TimerStatus.stopped)
              .toList();

          if (finishedTimers.isEmpty) {
            return Center(child: Text(l10n.no_history_yet));
          }

          return Column(
            children: [
              Expanded(child: _buildChart(finishedTimers)),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    thickness: 1,
                  ),
                  itemCount: finishedTimers.length,
                  itemBuilder: (context, index) {
                    final timer = finishedTimers[index];
                    final time = Duration(seconds: timer.elapsedSeconds);

                    String twoDigits(int n) => n.toString().padLeft(2, '0');
                    final hours = twoDigits(time.inHours);
                    final minutes = twoDigits(time.inMinutes.remainder(60));
                    final seconds = twoDigits(time.inSeconds.remainder(60));

                    return ListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: getAvatarColor(timer.name),
                              child: Text(
                                timer.name.substring(0, 2),
                                style: context.textTheme.titleMedium!.copyWith(
                                  color: context.colors.white,
                                ),
                              )),
                          const SizedBox(width: Spacing.s),
                          Text(
                            timer.name,
                            style: context.textTheme.titleLarge,
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          const SizedBox(height: Spacing.s),
                          Row(
                            children: [
                              Text(
                                '${l10n.time} : ',
                                style: context.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: Spacing.s),
                              RichText(
                                text: TextSpan(
                                  style:
                                      context.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    if (hours != '00')
                                      TextSpan(
                                        text: '$hours ${l10n.hour}',
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    if (minutes != '00')
                                      TextSpan(
                                        text: ' $minutes ${l10n.minute}',
                                        style:
                                            const TextStyle(color: Colors.blue),
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
                              Text(
                                '${l10n.price} : ',
                                style: context.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: Spacing.s),
                              Text(
                                '${timer.totalPrice.toStringAsFixed(0)} ${l10n.riel}',
                                style: context.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.greenPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildChart(List<PersonTimer> timers) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= timers.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(timers[value.toInt()].name,
                      style: const TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          barGroups: timers.asMap().entries.map((entry) {
            final index = entry.key;
            final timer = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    toY: timer.totalPrice, color: Colors.blueAccent),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
