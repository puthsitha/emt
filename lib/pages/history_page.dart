import 'package:employee_work/blocs/timer_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final finishedTimers = state.timers
              .where((timer) => timer.status == TimerStatus.stopped)
              .toList();

          if (finishedTimers.isEmpty) {
            return const Center(child: Text('No history yet.'));
          }

          return Column(
            children: [
              Expanded(child: _buildChart(finishedTimers)),
              Expanded(
                child: ListView.builder(
                  itemCount: finishedTimers.length,
                  itemBuilder: (context, index) {
                    final timer = finishedTimers[index];
                    final time = Duration(seconds: timer.elapsedSeconds);

                    String twoDigits(int n) => n.toString().padLeft(2, '0');
                    final hours = twoDigits(time.inHours);
                    final minutes = twoDigits(time.inMinutes.remainder(60));
                    final seconds = twoDigits(time.inSeconds.remainder(60));

                    return ListTile(
                      title: Text(timer.name),
                      subtitle: Text(
                          'Time: $hours:$minutes:$seconds\nPrice: ${timer.totalPrice.toStringAsFixed(2)} Riels'),
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
              sideTitles: SideTitles(showTitles: true),
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
