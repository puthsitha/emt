import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class AddPerson extends StatefulWidget {
  const AddPerson({super.key, required this.context});

  final BuildContext context;

  @override
  State<AddPerson> createState() => _AddPersonState();
}

class _AddPersonState extends State<AddPerson> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final rateController = TextEditingController(text: "1000");
  final nameFocus = FocusNode();
  final rateFocus = FocusNode();

  @override
  Widget build(_) {
    final l10n = context.l10n;
    return AlertDialog(
      scrollable: false,
      title: Text(l10n.new_person),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              focusNode: nameFocus,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.person_name),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.name_cannot_be_empty;
                }
                return null;
              },
              onFieldSubmitted: (_) =>
                  FocusScope.of(context).requestFocus(rateFocus),
            ),
            const SizedBox(height: Spacing.l),
            TextFormField(
              controller: rateController,
              focusNode: rateFocus,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l10n.horuly_rate),
              validator: (value) {
                final text = value?.trim() ?? '';
                final rate = int.tryParse(text);
                if (text.isEmpty) {
                  return l10n.rate_is_required;
                } else if (rate == null || rate <= 0) {
                  return l10n.rate_must_be_positive_number;
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final isValid = _formKey.currentState!.validate();

            if (!isValid) {
              if (nameController.text.trim().isEmpty) {
                nameFocus.requestFocus();
              } else if (int.tryParse(rateController.text.trim()) == null ||
                  int.parse(rateController.text.trim()) <= 0) {
                rateFocus.requestFocus();
              }
              return;
            }

            final id = const Uuid().v4();
            final name = nameController.text.trim();
            final rate = int.parse(rateController.text.trim());

            context.read<TimerBloc>().add(
                  StartTimer(id: id, name: name, hourlyRate: rate.toDouble()),
                );
            context.pop();
          },
          child: Text(l10n.start, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
