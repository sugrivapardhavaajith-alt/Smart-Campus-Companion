/// Application Constants for Campusly
class AppConstants {
  static const String appName = 'Campusly';
  static const String appTagline = 'Your campus. Your day. Simplified.';
  static const String appVersion = 'v1.0.0 (Build 2026)';
  static const String appDescription =
      'Campusly is an all-in-one smart campus companion application crafted to empower university students. Track weekly class schedules, monitor attendance statistics, discover and RSVP to campus events, and organize academic assignments with ease.';

  // Default Student Profile Information
  static const String studentName = 'Alex Morgan';
  static const String studentId = 'STU2026001';
  static const String studentEmail = 'alex.morgan@campusly.edu';
  static const String studentMajor = 'Computer Science & Engineering';
  static const String studentYear = '3rd Year • Semester 6';
  static const String studentCgpa = '3.84 / 4.00';
  static const String studentCredits = '24 Credits';
  static const String universityName = 'Apex Institute of Technology';

  // Navigation Route Names
  static const String routeWelcome = '/';
  static const String routeMain = '/main';
  static const String routeAttendance = '/attendance';
  static const String routeAssignments = '/assignments';
  static const String routeEventDetails = '/event-details';
  static const String routeAbout = '/about';

  // Days of Academic Week
  static const List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  // Event Categories
  static const List<String> eventCategories = [
    'All',
    'Technical',
    'Cultural',
    'Sports',
    'Workshops',
  ];

  // Assignment Priorities
  static const List<String> priorityLevels = [
    'High',
    'Medium',
    'Low',
  ];
}
