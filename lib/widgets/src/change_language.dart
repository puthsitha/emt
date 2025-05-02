import 'package:employee_work/blocs/lang/language_bloc.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key, required this.context});

  final BuildContext context;

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  late Locale _selectedLanguage;

  @override
  void initState() {
    final languageState = context.read<LanguageBloc>().state;
    _selectedLanguage = languageState.selectLanguage;
    super.initState();
  }

  void _onSaveLanguage() {
    context
        .read<LanguageBloc>()
        .add(LanguageAppChange(locale: _selectedLanguage));
    Navigator.pop(context);
  }

  @override
  Widget build(_) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.language),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLanguageOption('km', 'ខ្មែរ', 'assets/images/km_flag.png'),
          _buildLanguageOption('en', 'English', 'assets/images/en_flag.png'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _onSaveLanguage,
          child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  Widget _buildLanguageOption(String code, String label, String image) {
    return ListTile(
      title: Text(label),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          width: 30,
          height: 20,
          image,
        ),
      ),
      trailing: Radio<Locale>(
        value: Locale(code),
        groupValue: _selectedLanguage,
        onChanged: (value) {
          setState(() {
            _selectedLanguage = value!;
          });
        },
      ),
    );
  }
}
