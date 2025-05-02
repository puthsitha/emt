// ignore_for_file: avoid_renaming_method_parameters

import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DeletePerson extends StatelessWidget {
  const DeletePerson({super.key, required this.context, required this.id});

  final BuildContext context;
  final String id;

  @override
  Widget build(_) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.delete_person),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.are_you_sure_you_wanna_delete),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<TimerBloc>().add(DeleteTimer(id));
            context.pop();
          },
          child: Text(l10n.delete, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
