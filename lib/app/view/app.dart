import 'package:employee_work/blocs/lang/language_bloc.dart';
import 'package:employee_work/blocs/theme/theme_bloc.dart';
import 'package:employee_work/blocs/timer/timer_bloc.dart';
import 'package:employee_work/core/enums/enum.dart';
import 'package:employee_work/core/routes/routes.dart';
import 'package:employee_work/core/theme/src/dark_theme.dart';
import 'package:employee_work/core/theme/theme.dart';
import 'package:employee_work/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/intl.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    _initSplashScreen();
    super.initState();
  }

  Future<void> _initSplashScreen() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = AppRouter.router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(),
        ),
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final languageState = context.watch<LanguageBloc>().state;
          final themeState = context.watch<ThemeBloc>().state;
          Intl.defaultLocale =
              languageState.selectLanguage == const Locale('km')
                  ? 'km_KH'
                  : 'en_US';
          return GestureDetector(
            onTap: () {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            child: MaterialApp.router(
              // showPerformanceOverlay: true, // show performance overlay
              theme: themeState.selectTheme == ThemeColor.darkMode
                  ? darkTheme
                  : lightTheme,
              locale: languageState.selectLanguage,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: goRouter,
              builder: (context, child) {
                final childToast = MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: TextScaler.noScaling,
                  ),
                  child: child!,
                );
                return childToast;
              },
            ),
          );
        },
      ),
    );
  }
}
