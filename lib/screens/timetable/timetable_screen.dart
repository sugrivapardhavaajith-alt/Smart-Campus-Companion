import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../state/app_state.dart';
import '../../widgets/subject_card.dart';

/// Screen 3: Weekly Timetable with Animated Day Selector and Class Timeline
class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedDay = appState.selectedDay;
    final dayClasses = appState.classesForSelectedDay;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Timetable'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Timetable Info'),
                  content: const Text(
                    'All lectures and laboratory sessions are synchronized with the Spring 2026 Academic Schedule. Attendance requirements apply to all marked sessions.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Understood'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Schedule Information',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Horizontal Animated Day Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: _buildDaySelector(context, appState, isDark),
                    ),

                    const SizedBox(height: 6),

                    // Day Header Summary
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$selectedDay\'s Schedule',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${dayClasses.length} Scheduled Sessions',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : AppColors.softLavender,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time_filled,
                                  size: 14,
                                  color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Current Week',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Classes Timeline List
                    Expanded(
                      child: dayClasses.isEmpty
                          ? _buildEmptyState(selectedDay, isDark)
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              itemCount: dayClasses.length,
                              itemBuilder: (context, index) {
                                final item = dayClasses[index];
                                return SubjectCard(
                                  classItem: item,
                                  isNext: index == 0,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context, AppState appState, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: AppConstants.weekDays.map((day) {
          final isSelected = day == appState.selectedDay;
          final shortName = day.substring(0, 3).toUpperCase();

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => appState.setSelectedDay(day),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected
                      ? null
                      : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: 1.2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shortName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textMutedLight : AppColors.textSecondaryLight),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(String day, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.softLavender,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                size: 48,
                color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'No Classes on $day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no scheduled lectures or lab periods for this day. Use this time to catch up on assignments or study for exams!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
