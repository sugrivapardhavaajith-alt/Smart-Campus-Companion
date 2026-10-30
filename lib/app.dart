import 'package:flutter/material.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/attendance/attendance_screen.dart';
import 'screens/assignments/assignments_screen.dart';
import 'state/app_state.dart';

/// Root Application Widget with Material 3 Theme Management & Named Routing
class CampuslyApp extends StatefulWidget {
  const CampuslyApp({super.key});

  @override
  State<CampuslyApp> createState() => _CampuslyAppState();
}

class _CampuslyAppState extends State<CampuslyApp> {
  final AppState _appState = AppState();

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
      child: ListenableBuilder(
        listenable: _appState,
        builder: (context, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _appState.themeMode,
            initialRoute: AppConstants.routeWelcome,
            routes: {
              AppConstants.routeWelcome: (context) => const WelcomeScreen(),
              AppConstants.routeMain: (context) => const MainNavigationScreen(),
              AppConstants.routeAttendance: (context) => const AttendanceScreen(),
              AppConstants.routeAssignments: (context) => const AssignmentsScreen(),
            },
          );
        },
      ),
    );
  }
}
