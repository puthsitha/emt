import 'package:employee_work/blocs/timer_bloc.dart';
import 'package:employee_work/core/routes/routes.dart';
import 'package:employee_work/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // await Future<void>.delayed(const Duration(seconds: 5));
    // FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = AppRouter.router;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TimerBloc(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
            },
            child: MaterialApp.router(
              // showPerformanceOverlay: true, // show performance overlay
              theme: lightTheme,
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
