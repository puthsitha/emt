import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:employee_work/core/extensions/src/build_context_ext.dart';
import 'package:employee_work/core/routes/src/not_found_screen.dart';
import 'package:employee_work/core/theme/theme.dart';
import 'package:employee_work/pages/employee_form_page.dart';
import 'package:employee_work/pages/history_page.dart';
import 'package:employee_work/pages/home_page.dart';
import 'package:employee_work/pages/setting_page.dart';
import 'package:employee_work/pages/splash_page.dart';
import 'package:employee_work/pages/voice_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum Pages {
  // Splash
  splash,
  //home
  app,
  //home
  home,
  employeeForm,
  //history,
  history,
  //setting
  setting,
  voice,
}

class AppRouter {
  AppRouter();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static late StatefulNavigationShell navigationBottomBarShell;

  static late ScrollController homeScrollController;

  static final homeShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'home');
  static final historyShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'history');
  static final settingShellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'setting');

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
        name: Pages.app.name,
        path: '/app',
        redirect: (context, state) {
          if (state.fullPath == '/app') {
            return '/app/home';
          }
          return null;
        },
        routes: [
          StatefulShellRoute.indexedStack(
              builder: (context, state, navigationShell) {
                navigationBottomBarShell = navigationShell;
                return BottomNavigationPage(
                  child: navigationShell,
                );
              },
              branches: [
                StatefulShellBranch(
                  navigatorKey: homeShellNavigatorKey,
                  routes: [
                    GoRoute(
                      name: Pages.home.name,
                      path: '/home',
                      pageBuilder: (context, state) {
                        return HomePage.page(key: state.pageKey);
                      },
                      routes: [
                        GoRoute(
                          path: 'employee-form',
                          name: Pages.employeeForm.name,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            return EmployeeFormPage.page(
                              key: state.pageKey,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                StatefulShellBranch(
                  navigatorKey: historyShellNavigatorKey,
                  routes: [
                    GoRoute(
                      name: Pages.history.name,
                      path: 'history',
                      pageBuilder: (context, state) {
                        return HistoryPage.page(key: state.pageKey);
                      },
                    ),
                  ],
                ),
                StatefulShellBranch(
                  navigatorKey: settingShellNavigatorKey,
                  routes: [
                    GoRoute(
                      path: 'setting',
                      name: Pages.setting.name,
                      pageBuilder: (context, state) {
                        return SettingPage.page(
                          key: state.pageKey,
                        );
                      },
                      routes: [
                        GoRoute(
                          path: 'voice',
                          name: Pages.voice.name,
                          parentNavigatorKey: rootNavigatorKey,
                          pageBuilder: (context, state) {
                            return VoicePage.page(
                              key: state.pageKey,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ]),
        ],
      ),
    ],
  );
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: context.colors.transparent,
        buttonBackgroundColor: context.colors.primary,
        color: context.colors.primary,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: widget.child.currentIndex == 0
                ? AppColors.white
                : AppColors.white.withOpacity(0.5),
          ),
          Icon(
            Icons.auto_graph_outlined,
            size: 30,
            color: widget.child.currentIndex == 1
                ? AppColors.white
                : AppColors.white.withOpacity(0.5),
          ),
          Icon(
            Icons.settings,
            size: 30,
            color: widget.child.currentIndex == 2
                ? AppColors.white
                : AppColors.white.withOpacity(0.5),
          ),
        ],
        onTap: (index) {
          if (index == widget.child.currentIndex) return;
          widget.child.goBranch(
            index,
            initialLocation: index == widget.child.currentIndex,
          );
        },
      ),
      body: widget.child,
    );
  }
}
