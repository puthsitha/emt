import 'package:employee_work/core/routes/src/not_found_screen.dart';
import 'package:employee_work/pages/history_page.dart';
import 'package:employee_work/pages/home_page.dart';
import 'package:employee_work/pages/splash_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Pages {
  // Splash
  splash,
  //home
  home,
  //history,
  history,
}

class AppRouter {
  AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static late StatefulNavigationShell navigationBottomBarShell;

  static late ScrollController homeScrollController;

  static final homeShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'home');

  static GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (kDebugMode) {
        print('route fullPath : ${state.fullPath}');
      }
      return null;
    },
    errorPageBuilder: (context, state) {
      return NotFoundScreen.page(key: state.pageKey);
    },
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        name: Pages.splash.name,
        path: '/',
        pageBuilder: (context, state) {
          return SplashPage.page(key: state.pageKey);
        },
      ),
      GoRoute(
          name: Pages.home.name,
          path: '/app',
          pageBuilder: (context, state) {
            return HomePage.page(key: state.pageKey);
          },
          routes: [
            GoRoute(
              name: Pages.history.name,
              path: 'history',
              pageBuilder: (context, state) {
                return HistoryPage.page(key: state.pageKey);
              },
            ),
          ]),
    ],
  );
}
