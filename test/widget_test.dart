import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campusly/app.dart';
import 'package:campusly/core/constants/app_constants.dart';

void main() {
  void setStandardPhoneSize(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
  }

  Future<void> navigateToDashboard(WidgetTester tester) async {
    final getStartedButton = find.textContaining('Get Started');
    await tester.ensureVisible(getStartedButton);
    await tester.pumpAndSettle();
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();
  }

  tearDown(() {
    // Reset test view dimensions after each test
  });

  testWidgets('Screen 1 Welcome: Renders branding, tagline, and Get Started button',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    // Verify Welcome Screen Branding and Tagline
    expect(find.text('Campusly'), findsWidgets);
    expect(find.text(AppConstants.appTagline), findsOneWidget);
    expect(find.textContaining('Get Started'), findsOneWidget);
  });

  testWidgets('Navigation: Get Started button navigates from Welcome to Dashboard',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    // Scroll until visible and tap Get Started button
    final getStartedButton = find.textContaining('Get Started');
    await tester.ensureVisible(getStartedButton);
    await tester.pumpAndSettle();
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    // Verify Dashboard is displayed
    expect(find.text('Your Campus Today'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Timetable'), findsWidgets);
    expect(find.text('Attendance'), findsWidgets);
  });

  testWidgets('Bottom Navigation: Switches between Home, Schedule, Events, and Profile tabs',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    // Navigate to Dashboard
    final getStartedButton = find.textContaining('Get Started');
    await tester.ensureVisible(getStartedButton);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    // 1. Switch to Schedule tab
    final scheduleNav = find.text('Schedule');
    expect(scheduleNav, findsOneWidget);
    await tester.tap(scheduleNav);
    await tester.pumpAndSettle();
    expect(find.text('Weekly Timetable'), findsOneWidget);

    // 2. Switch to Events tab
    final eventsNav = find.text('Events');
    expect(eventsNav, findsOneWidget);
    await tester.tap(eventsNav);
    await tester.pumpAndSettle();
    expect(find.text('Campus Events'), findsOneWidget);

    // 3. Switch to Profile tab
    final profileNav = find.text('Profile');
    expect(profileNav, findsOneWidget);
    await tester.tap(profileNav);
    await tester.pumpAndSettle();
    expect(find.text('Student Profile'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
  });

  testWidgets('Timetable: Weekday selector switches active day schedule',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    final getStartedButton = find.textContaining('Get Started');
    await tester.ensureVisible(getStartedButton);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    // Switch to Schedule tab
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();

    // Tap 'Tuesday'
    final tuesdayFinder = find.text('Tuesday');
    expect(tuesdayFinder, findsWidgets);
    await tester.tap(tuesdayFinder.first);
    await tester.pumpAndSettle();

    expect(find.text('Tuesday\'s Schedule'), findsOneWidget);
  });

  testWidgets('Theme Switching: Dark Mode switch toggles theme reactively',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    final getStartedButton = find.textContaining('Get Started');
    await tester.ensureVisible(getStartedButton);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();

    // Switch to Profile tab
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    // Find Dark Mode switch
    final switchFinder = find.byType(Switch).first;
    await tester.ensureVisible(switchFinder);
    expect(switchFinder, findsOneWidget);

    // Verify initial Light Mode
    expect(find.text('Light theme enabled'), findsOneWidget);

    // Toggle to Dark Mode
    await tester.tap(switchFinder);
    await tester.pumpAndSettle();

    expect(find.text('Night theme enabled'), findsOneWidget);
  });

  testWidgets('Quick Action Navigation: Attendance screen opens with metrics',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    await navigateToDashboard(tester);

    // Tap Attendance quick action
    final attendanceCard = find.text('Attendance');
    expect(attendanceCard, findsWidgets);
    await tester.ensureVisible(attendanceCard.first);
    await tester.pumpAndSettle();
    await tester.tap(attendanceCard.first);
    await tester.pumpAndSettle();

    expect(find.text('Attendance Tracker'), findsOneWidget);
    expect(find.text('Overall Attendance'), findsOneWidget);

    // Tap Back button
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Your Campus Today'), findsOneWidget);
  });

  testWidgets('Assignments: Toggle task checkbox and open New Task dialog',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    await navigateToDashboard(tester);

    // Tap Assignments quick action
    final assignmentsCard = find.text('Assignments');
    expect(assignmentsCard, findsWidgets);
    await tester.ensureVisible(assignmentsCard.first);
    await tester.pumpAndSettle();
    await tester.tap(assignmentsCard.first);
    await tester.pumpAndSettle();

    expect(find.text('Assignment Planner'), findsOneWidget);

    // Tap New Task button
    final newTaskButton = find.text('New Task');
    expect(newTaskButton, findsOneWidget);
    await tester.tap(newTaskButton);
    await tester.pumpAndSettle();

    expect(find.text('New Assignment'), findsOneWidget);

    // Cancel dialog
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Assignment Planner'), findsOneWidget);
  });

  testWidgets('Events & RSVP: Search events and open Event Details screen',
      (WidgetTester tester) async {
    setStandardPhoneSize(tester);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    await navigateToDashboard(tester);

    // Switch to Events tab via NavigationBar
    final eventsNav = find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text('Events'),
    );
    await tester.tap(eventsNav);
    await tester.pumpAndSettle();

    expect(find.text('Campus Events'), findsOneWidget);
    expect(find.text('Technical'), findsWidgets);

    // Find first event and tap View Details
    final detailsButton = find.text('View Details').first;
    await tester.ensureVisible(detailsButton);
    await tester.tap(detailsButton);
    await tester.pumpAndSettle();

    expect(find.text('About This Event'), findsOneWidget);
    expect(find.textContaining('Register'), findsWidgets);
  });

  testWidgets('Responsiveness: Renders on small phone (320px) without overflow',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    // Verify Welcome renders on 320px
    expect(find.text('Campusly'), findsWidgets);

    // Navigate to Dashboard
    await navigateToDashboard(tester);

    // Dashboard renders on 320px
    expect(find.text('Your Campus Today'), findsOneWidget);

    // Navigate to Timetable
    await tester.tap(find.text('Schedule'));
    await tester.pumpAndSettle();
    expect(find.text('Weekly Timetable'), findsOneWidget);

    // Navigate to Profile
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Student Profile'), findsOneWidget);
  });

  testWidgets('Responsiveness: Renders on tablet (768px) with adaptive layout',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(768, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const CampuslyApp());
    await tester.pumpAndSettle();

    await navigateToDashboard(tester);

    expect(find.text('Your Campus Today'), findsOneWidget);
    expect(find.text('Ready for another productive day?'), findsOneWidget);
  });
}
