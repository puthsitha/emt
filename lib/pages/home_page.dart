// ignore_for_file: depend_on_referenced_packages

import 'package:employee_work/blocs/timer_bloc.dart';
import 'package:employee_work/core/routes/src/app_router.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/models/person_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
        child: HomePage(key: key),
      );

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.pushNamed(Pages.history.name);
            },
          ),
        ],
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state.timers.isEmpty) {
            return const Center(child: Text('No timers yet. Start one!'));
          }
          return ListView.builder(
            itemCount: state.timers.length,
            itemBuilder: (context, index) {
              final timer = state.timers[index];
              return _TimerCard(timer: timer);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePersonDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreatePersonDialog(BuildContext context) {
    final nameController = TextEditingController();
    final rateController = TextEditingController(text: "1000");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Timer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Person Name'),
            ),
            const SizedBox(height: Spacing.l),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Hourly Rate (Riel)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = const Uuid().v4();
              final name = nameController.text.trim();
              final rateText = rateController.text.trim();
              final rate = double.tryParse(rateText) ?? 1000;

              if (name.isNotEmpty && rateText.isNotEmpty) {
                context
                    .read<TimerBloc>()
                    .add(StartTimer(id: id, name: name, hourlyRate: rate));
              }
              Navigator.pop(context);
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _TimerCard extends StatelessWidget {
  final PersonTimer timer;

  const _TimerCard({required this.timer});

  @override
  Widget build(BuildContext context) {
    final totalTime = Duration(seconds: timer.currentElapsedSeconds());
    final price = timer.totalPrice;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(totalTime.inHours);
    final minutes = twoDigits(totalTime.inMinutes.remainder(60));
    final seconds = twoDigits(totalTime.inSeconds.remainder(60));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: ListTile(
        title: Text(timer.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$hours:$minutes:$seconds'),
            Text('Price: ${price.toStringAsFixed(2)} Riels'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (timer.status == TimerStatus.running)
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  context.read<TimerBloc>().add(PauseTimer(timer.id));
                },
              )
            else if (timer.status == TimerStatus.paused)
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  context.read<TimerBloc>().add(ResumeTimer(timer.id));
                },
              ),
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                context.read<TimerBloc>().add(StopTimer(timer.id));
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<TimerBloc>().add(DeleteTimer(timer.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
