import 'package:employee_work/blocs/theme/theme_bloc.dart';
import 'package:employee_work/core/enums/enum.dart';
import 'package:employee_work/core/extensions/extension.dart';
import 'package:employee_work/core/theme/spacing.dart';
import 'package:employee_work/core/theme/theme.dart';
import 'package:employee_work/core/utils/util.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:employee_work/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static MaterialPage<void> page({Key? key}) => MaterialPage<void>(
        child: SettingPage(key: key),
      );

  @override
  Widget build(BuildContext context) {
    return const SettingView();
  }
}

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: context.colors.neutral100,
      appBar: AppBar(
        title: Text(
          l10n.setting,
          style: context.textTheme.headlineLarge!.copyWith(
            color: AppColors.white,
          ),
        ),
        backgroundColor: context.colors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.l),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: Spacing.l),
            ListTile(
              leading: const Icon(
                Icons.language,
                size: 40,
                color: Colors.tealAccent,
              ),
              title: Text(
                l10n.language,
                style: context.textTheme.titleLarge,
              ),
              subtitle: Text(
                l10n.press_here_change_language,
                style: context.textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showLanguageDialog(context),
            ),
            const SizedBox(height: Spacing.sm),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return ListTile(
                  leading: Icon(
                    themeState.selectTheme == ThemeColor.darkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    size: 40,
                    color: themeState.selectTheme == ThemeColor.darkMode
                        ? Colors.indigoAccent
                        : Colors.amberAccent,
                  ),
                  title: Text(
                    l10n.theme,
                    style: context.textTheme.titleLarge,
                  ),
                  subtitle: Text(
                    l10n.customize_theme_appearance,
                    style: context.textTheme.bodyLarge,
                  ),
                  trailing: Switch(
                    value: themeState.selectTheme == ThemeColor.darkMode,
                    onChanged: (value) {
                      final newTheme =
                          value ? ThemeColor.darkMode : ThemeColor.lightMode;
                      context
                          .read<ThemeBloc>()
                          .add(ThemeAppChange(theme: newTheme));
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: Spacing.sm),
            ListTile(
              leading: const Icon(
                Icons.call,
                size: 40,
                color: Colors.pinkAccent,
              ),
              title: Text(
                l10n.call_developer,
                style: context.textTheme.titleLarge,
              ),
              subtitle: Text(
                l10n.call_developer_description,
                style: context.textTheme.bodyLarge,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                DeeplinkHelper.makePhoneCall(mobile: '092389497');
              },
            ),
          ],
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: context.colors.neutral100,
            child: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.l9),
              child: Center(
                child: Text(
                  '${l10n.copyright} ©️ ${l10n.version} 1.0.0',
                  style: context.textTheme.titleMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => ChangeLanguage(
              context: context,
            ));
  }
}
