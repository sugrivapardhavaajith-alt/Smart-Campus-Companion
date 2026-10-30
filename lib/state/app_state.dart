import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../models/event_model.dart';
import '../models/assignment_model.dart';
import '../models/attendance_model.dart';
import '../data/mock_data.dart';

/// Central In-Memory State Manager for Campusly
class AppState extends ChangeNotifier {
  // Theme State
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // Preferences
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  // Navigation State
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // Timetable State
  String _selectedDay = 'Monday';
  String get selectedDay => _selectedDay;

  final List<ClassModel> _classes = List.from(MockData.initialClasses);
  List<ClassModel> get classes => List.unmodifiable(_classes);

  List<ClassModel> get classesForSelectedDay =>
      _classes.where((c) => c.day == _selectedDay).toList();

  void setSelectedDay(String day) {
    _selectedDay = day;
    notifyListeners();
  }

  // Attendance State
  final List<AttendanceModel> _attendance = List.from(MockData.initialAttendance);
  List<AttendanceModel> get attendance => List.unmodifiable(_attendance);

  int get totalAttendedClasses =>
      _attendance.fold(0, (sum, item) => sum + item.attendedClasses);

  int get totalScheduledClasses =>
      _attendance.fold(0, (sum, item) => sum + item.totalClasses);

  double get overallAttendancePercentage {
    if (totalScheduledClasses == 0) return 0.0;
    return (totalAttendedClasses / totalScheduledClasses) * 100;
  }

  String get overallAttendanceFormatted =>
      '${overallAttendancePercentage.toStringAsFixed(1)}%';

  // Campus Events State
  final List<EventModel> _events = List.from(MockData.initialEvents);
  List<EventModel> get events => List.unmodifiable(_events);

  bool toggleEventRegistration(String eventId) {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      final current = _events[index];
      final newStatus = !current.isRegistered;
      final newCount = newStatus ? current.registeredCount + 1 : current.registeredCount - 1;
      _events[index] = current.copyWith(
        isRegistered: newStatus,
        registeredCount: newCount,
      );
      notifyListeners();
      return newStatus;
    }
    return false;
  }

  // Assignments State
  final List<AssignmentModel> _assignments = List.from(MockData.initialAssignments);
  List<AssignmentModel> get assignments => List.unmodifiable(_assignments);

  int get pendingAssignmentsCount =>
      _assignments.where((a) => !a.isCompleted).length;

  int get completedAssignmentsCount =>
      _assignments.where((a) => a.isCompleted).length;

  double get assignmentProgress {
    if (_assignments.isEmpty) return 0.0;
    return completedAssignmentsCount / _assignments.length;
  }

  void toggleAssignmentCompletion(String assignmentId) {
    final index = _assignments.indexWhere((a) => a.id == assignmentId);
    if (index != -1) {
      final current = _assignments[index];
      _assignments[index] = current.copyWith(isCompleted: !current.isCompleted);
      notifyListeners();
    }
  }

  void addAssignment({
    required String title,
    required String subject,
    required String dueDate,
    required String priority,
    String notes = '',
  }) {
    final newAssignment = AssignmentModel(
      id: 'asg_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subject: subject,
      dueDate: dueDate,
      priority: priority,
      isCompleted: false,
      notes: notes,
    );
    _assignments.insert(0, newAssignment);
    notifyListeners();
  }

  void deleteAssignment(String id) {
    _assignments.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}

/// InheritedWidget wrapper or provider access
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No AppStateScope found in context');
    return scope!.notifier!;
  }
}
