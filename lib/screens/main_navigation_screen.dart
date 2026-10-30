import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'home/home_screen.dart';
import 'timetable/timetable_screen.dart';
import 'events/events_screen.dart';
import 'profile/profile_screen.dart';

/// Primary Persistent Navigation Shell connecting the 4 primary tabs
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final currentIndex = appState.currentTabIndex;

    final List<Widget> screens = [
      HomeScreen(
        onNavigateToSchedule: () => appState.setTabIndex(1),
        onNavigateToEvents: () => appState.setTabIndex(2),
      ),
      const TimetableScreen(),
      const EventsScreen(),
      const ProfileScreen(),
    ];

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && currentIndex != 0) {
          appState.setTabIndex(0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            appState.setTabIndex(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
              tooltip: 'Home Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded),
              label: 'Schedule',
              tooltip: 'Weekly Timetable',
            ),
            NavigationDestination(
              icon: Icon(Icons.celebration_outlined),
              selectedIcon: Icon(Icons.celebration_rounded),
              label: 'Events',
              tooltip: 'Campus Events',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
              tooltip: 'Student Profile',
            ),
          ],
        ),
      ),
    );
  }
}
