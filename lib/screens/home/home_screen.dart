import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';
import '../../widgets/subject_card.dart';
import '../../widgets/event_card.dart';
import '../events/event_details_screen.dart';

/// Screen 2: Home Dashboard — The central academic overview of Campusly
class HomeScreen extends StatelessWidget {
  final VoidCallback onNavigateToSchedule;
  final VoidCallback onNavigateToEvents;

  const HomeScreen({
    super.key,
    required this.onNavigateToSchedule,
    required this.onNavigateToEvents,
  });

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final dayName = days[now.weekday - 1];
    final monthName = months[now.month - 1];
    return '$dayName, $monthName ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 650;

    // Filter today's classes (Monday by default in mock)
    final todayClasses = appState.classes.where((c) => c.day == 'Monday').toList();
    final nextClass = todayClasses.isNotEmpty ? todayClasses.first : null;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulated pull-to-refresh
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top App Bar / Profile Header
                    _buildTopHeader(context, isDark),

                    const SizedBox(height: 20),

                    // Main Hero Card: "Your Campus Today"
                    _buildHeroCard(context, nextClass, isDark),

                    const SizedBox(height: 24),

                    // Quick Actions Section
                    SectionHeader(
                      title: 'Quick Actions',
                      subtitle: 'Direct shortcuts to academic tools',
                      icon: Icons.bolt_rounded,
                    ),
                    const SizedBox(height: 8),
                    _buildQuickActions(context, isDark, isTablet),

                    const SizedBox(height: 24),

                    // Academic Overview Statistics Grid
                    SectionHeader(
                      title: 'Academic Pulse',
                      subtitle: 'Real-time performance snapshot',
                      icon: Icons.analytics_outlined,
                    ),
                    const SizedBox(height: 8),
                    _buildMetricsGrid(context, appState, isDark, isTablet),

                    const SizedBox(height: 24),

                    // Today's Schedule Section
                    SectionHeader(
                      title: 'Today\'s Classes',
                      subtitle: '${todayClasses.length} lectures scheduled for today',
                      icon: Icons.calendar_today_rounded,
                      actionTitle: 'Full Timetable',
                      onActionTap: onNavigateToSchedule,
                    ),
                    const SizedBox(height: 8),
                    if (todayClasses.isEmpty)
                      _buildEmptyClasses(isDark)
                    else
                      ...todayClasses.map((item) {
                        final isFirst = item.id == todayClasses.first.id;
                        return SubjectCard(classItem: item, isNext: isFirst);
                      }),

                    const SizedBox(height: 20),

                    // Upcoming Events Preview
                    SectionHeader(
                      title: 'Featured Campus Events',
                      subtitle: 'Don\'t miss what\'s happening around campus',
                      icon: Icons.celebration_outlined,
                      actionTitle: 'Explore All',
                      onActionTap: onNavigateToEvents,
                    ),
                    const SizedBox(height: 12),
                    _buildEventsCarousel(context, appState),

                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting & Current Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      _getFormattedDate(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  children: [
                    const TextSpan(text: 'Good morning, '),
                    TextSpan(
                      text: 'Alex 👋',
                      style: TextStyle(
                        color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Ready for another productive day?',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Actions: Notification bell + Avatar
        Row(
          children: [
            // Notification Bell with Badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, size: 22),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You have 2 unread campus announcements.'),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    tooltip: 'Notifications',
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.backgroundDark : Colors.white,
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Student Avatar
            GestureDetector(
              onTap: () {
                // Navigate to Profile tab
                AppStateScope.of(context).setTabIndex(3);
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/student_avatar.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, dynamic nextClass, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Asset Image overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/images/campus_banner.png',
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // Decorative circular glow
          Positioned(
            right: -20,
            bottom: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Right-side Photo Feature with soft gradient blend
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: (MediaQuery.of(context).size.width * 0.42).clamp(110.0, 220.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/campus_hero.jpg',
                    fit: BoxFit.cover,
                    alignment: const Alignment(0.2, 0.0),
                    errorBuilder: (context, error, stackTrace) => const SizedBox(),
                  ),
                  // Elegant gradient blend to smoothly fuse with the card's primary gradient
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          (isDark
                              ? AppColors.darkHeroGradient.colors.first
                              : AppColors.primaryGradient.colors.first),
                          (isDark
                                  ? AppColors.darkHeroGradient.colors.first
                                  : AppColors.primaryGradient.colors.first)
                              .withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.35, 0.85],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badge
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Your Campus Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Semester 6',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Next Class Label
                Text(
                  'UPCOMING NEXT CLASS',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),

                // Subject Name
                Text(
                  nextClass != null ? nextClass.subjectName : 'No more classes today',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Meta: Room + Time
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.room_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(
                            nextClass != null ? nextClass.classroom : 'Campus Grounds',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 180),
                          child: Text(
                            nextClass != null ? nextClass.timeSlot : 'Free Day',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // View Schedule Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: onNavigateToSchedule,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            'View Full Schedule',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark, bool isTablet) {
    final actions = [
      {
        'title': 'Timetable',
        'subtitle': 'Weekly plan',
        'icon': Icons.calendar_month_rounded,
        'color': AppColors.primary,
        'action': onNavigateToSchedule,
      },
      {
        'title': 'Attendance',
        'subtitle': '85.2% Overall',
        'icon': Icons.fact_check_rounded,
        'color': AppColors.accentCyan,
        'action': () {
          Navigator.of(context).pushNamed(AppConstants.routeAttendance);
        },
      },
      {
        'title': 'Assignments',
        'subtitle': 'Tasks & tests',
        'icon': Icons.assignment_outlined,
        'color': AppColors.warning,
        'action': () {
          Navigator.of(context).pushNamed(AppConstants.routeAssignments);
        },
      },
      {
        'title': 'Events',
        'subtitle': 'Fest & tech',
        'icon': Icons.celebration_rounded,
        'color': AppColors.secondary,
        'action': onNavigateToEvents,
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isTablet ? 1.35 : 1.0,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final item = actions[index];
        final iconColor = item['color'] as Color;

        return CustomCard(
          onTap: item['action'] as VoidCallback,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: iconColor,
                  size: 20,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['subtitle'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricsGrid(BuildContext context, AppState appState, bool isDark, bool isTablet) {
    final metrics = [
      {
        'label': 'Attendance',
        'value': appState.overallAttendanceFormatted,
        'sub': '${appState.totalAttendedClasses}/${appState.totalScheduledClasses} Classes',
        'color': AppColors.success,
        'icon': Icons.check_circle_outline,
        'onTap': () => Navigator.of(context).pushNamed(AppConstants.routeAttendance),
      },
      {
        'label': 'Assignments',
        'value': '${appState.pendingAssignmentsCount} Due',
        'sub': '${appState.completedAssignmentsCount} Completed',
        'color': AppColors.warning,
        'icon': Icons.pending_actions,
        'onTap': () => Navigator.of(context).pushNamed(AppConstants.routeAssignments),
      },
      {
        'label': 'Today\'s Classes',
        'value': '${appState.classesForSelectedDay.length}',
        'sub': 'Across 4 Subjects',
        'color': AppColors.primary,
        'icon': Icons.schedule_rounded,
        'onTap': onNavigateToSchedule,
      },
      {
        'label': 'Campus Events',
        'value': '${appState.events.length}',
        'sub': '${appState.events.where((e) => e.isRegistered).length} RSVPs Confirmed',
        'color': AppColors.secondary,
        'icon': Icons.local_activity_outlined,
        'onTap': onNavigateToEvents,
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isTablet ? 1.5 : 1.15,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final item = metrics[index];
        final color = item['color'] as Color;

        return CustomCard(
          onTap: item['onTap'] as VoidCallback,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(item['icon'] as IconData, size: 16, color: color),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['sub'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyClasses(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.weekend_outlined,
              size: 40,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
            ),
            const SizedBox(height: 8),
            Text(
              'No Classes Scheduled For Today',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Enjoy your free time or prepare for upcoming assignments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsCarousel(BuildContext context, AppState appState) {
    return SizedBox(
      height: 185,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: appState.events.length,
        itemBuilder: (context, index) {
          final event = appState.events[index];
          return EventCard(
            event: event,
            isHorizontal: true,
            heroTag: 'event_home_${event.id}',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EventDetailsScreen(
                    eventId: event.id,
                    heroTag: 'event_home_${event.id}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
