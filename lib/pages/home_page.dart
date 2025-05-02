// ignore_for_file: depend_on_referenced_packages

import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/core/extensions/src/build_context_ext.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/core/theme/theme.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:employee_work/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final l10n = context.l10n;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.colors.neutral96,
      appBar: AppBar(
        title: Text(
          l10n.tmie_manager,
          style: context.textTheme.headlineLarge!.copyWith(
            color: AppColors.white,
          ),
        ),
        backgroundColor: context.colors.primary,
        actions: [
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state.timers.isNotEmpty) {
                return PopupMenuButton(
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.menu_open_sharp),
                    itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'pause',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.pause,
                                  color: context.colors.orangePrimary,
                                ),
                                const SizedBox(width: Spacing.s),
                                Text(
                                  l10n.pause_all,
                                ),
                              ],
                            ),
                            onTap: () {
                              context.read<TimerBloc>().add(PauseAllTimers());
                            },
                          ),
                          PopupMenuItem(
                            value: 'resume',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: context.colors.primary,
                                ),
                                const SizedBox(width: Spacing.s),
                                Text(
                                  l10n.resume_all,
                                ),
                              ],
                            ),
                            onTap: () {
                              context.read<TimerBloc>().add(ResumeAllTimers());
                            },
                          ),
                          PopupMenuItem(
                              value: 'stop',
                              child: Row(
                                children: [
                                  Icon(Icons.stop,
                                      color: context.colors.redPrimary),
                                  const SizedBox(width: Spacing.s),
                                  Text(l10n.stop_all),
                                ],
                              ),
                              onTap: () {
                                context.read<TimerBloc>().add(StopAllTimers());
                              }),
                          PopupMenuItem(
                              value: 'reset',
                              child: Row(
                                children: [
                                  Icon(Icons.restart_alt,
                                      color: context.colors.purplePrimary),
                                  const SizedBox(width: Spacing.s),
                                  Text(l10n.reset_all),
                                ],
                              ),
                              onTap: () {
                                context.read<TimerBloc>().add(ResetAllTimers());
                              }),
                          PopupMenuItem(
                              value: 'restart',
                              child: Row(
                                children: [
                                  Icon(Icons.start,
                                      color: context.colors.greenPrimary),
                                  const SizedBox(width: Spacing.s),
                                  Text(
                                    l10n.restart_all,
                                  ),
                                ],
                              ),
                              onTap: () {
                                context
                                    .read<TimerBloc>()
                                    .add(ReStartAllTimers());
                              }),
                        ]);
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          if (state.timers.isEmpty) {
            return const SingleChildScrollView(child: EmptyData());
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: Spacing.s,
            ),
            padding: const EdgeInsets.only(
              top: Spacing.sm,
              right: Spacing.sm,
              left: Spacing.sm,
              bottom: Spacing.l10,
            ),
            itemCount: state.timers.length,
            itemBuilder: (context, index) {
              final timer = state.timers[index];
              return PersonCard(timer: timer);
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.l9),
        child: FloatingActionButton(
          onPressed: () => _showCreatePersonDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showCreatePersonDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AddPerson(
              context: context,
            ));
  }
}
