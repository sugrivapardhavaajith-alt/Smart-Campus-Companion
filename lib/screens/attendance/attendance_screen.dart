import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/attendance_model.dart';
import '../../state/app_state.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/section_header.dart';

/// Screen 4: Academic Attendance Tracker with subject-wise progress bars and filtering
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String _selectedFilter = 'All'; // All | Safe | Warning | Critical

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allAttendance = appState.attendance;
    final filteredAttendance = allAttendance.where((item) {
      if (_selectedFilter == 'All') return true;
      return item.status.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => _showPolicyDialog(context),
            tooltip: 'University Attendance Policy',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overall Academic Summary Card
                      ProgressCard(
                        title: 'Overall Attendance',
                        subtitle: 'Official University Threshold: 75.0%',
                        percentage: appState.overallAttendancePercentage,
                        metricPrimary: '${appState.totalAttendedClasses}',
                        metricPrimaryLabel: 'Attended Classes',
                        metricSecondary: '${appState.totalScheduledClasses}',
                        metricSecondaryLabel: 'Total Conducted',
                        accentColor: appState.overallAttendancePercentage >= 75.0
                            ? AppColors.success
                            : AppColors.warning,
                      ),

                      const SizedBox(height: 24),

                      // Attendance Filter Chips
                      SectionHeader(
                        title: 'Subject Breakdown',
                        subtitle: 'Detailed record per registered course',
                        icon: Icons.filter_list_rounded,
                      ),
                      const SizedBox(height: 8),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: ['All', 'Safe', 'Warning', 'Critical'].map((status) {
                            final isSelected = _selectedFilter == status;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(status),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      _selectedFilter = status;
                                    });
                                  }
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subject Attendance Cards List
                      if (filteredAttendance.isEmpty)
                        _buildEmptyFilterState(isDark)
                      else
                        ...filteredAttendance.map((item) => _buildSubjectAttendanceCard(item, isDark)),

                      const SizedBox(height: 24),

                      // Attendance Policy Guidance Alert Card
                      _buildPolicyGuidanceCard(isDark),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubjectAttendanceCard(AttendanceModel item, bool isDark) {
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Subject code & Status chip
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 6,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDarkElevated : AppColors.softLavender,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.subjectCode,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      item.faculty,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Status Pill with Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: item.statusColor,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Subject Name
          Text(
            item.subjectName,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),

          const SizedBox(height: 14),

          // Linear Progress Indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: item.ratio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: isDark
                  ? AppColors.surfaceDarkElevated
                  : AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(item.statusColor),
            ),
          ),

          const SizedBox(height: 10),

          // Bottom Stats: Attended vs Total & Formatted %
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    children: [
                      const TextSpan(text: 'Attended: '),
                      TextSpan(
                        text: '${item.attendedClasses}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      TextSpan(text: ' / ${item.totalClasses} classes'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.percentageFormatted,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: item.statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFilterState(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 40,
              color: AppColors.success,
            ),
            const SizedBox(height: 10),
            Text(
              'No Subjects with $_selectedFilter Status',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Great news! Keep up your academic consistency.',
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

  Widget _buildPolicyGuidanceCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.infoBgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_rounded, color: AppColors.info, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Minimum Attendance Requirement',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Students must maintain at least 75% attendance in each course to be eligible for end-semester examinations without penalty.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attendance Regulations'),
        content: const Text(
          'University regulations stipulate that all full-time undergraduate students must achieve ≥75% attendance in theory lectures and ≥80% in practical laboratory sessions to sit for semester examinations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
