import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../state/app_state.dart';
import '../../widgets/campusly_logo_widget.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/section_header.dart';

/// Screen 8: Student Profile and Application Settings with Dark Mode & Preference Switches
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showAboutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const CampuslyLogoWidget(size: 32, showText: false),
            const SizedBox(width: 10),
            const Text('About Campusly'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campusly — Smart Campus Companion',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                AppConstants.appDescription,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 8),
              _buildAboutMetaRow('Version', AppConstants.appVersion, isDark),
              const SizedBox(height: 6),
              _buildAboutMetaRow('Evaluation', 'Academic Lab Project (100 Marks)', isDark),
              const SizedBox(height: 6),
              _buildAboutMetaRow('Architecture', 'Flutter & Material Design 3', isDark),
              const SizedBox(height: 6),
              _buildAboutMetaRow('Platform Support', 'Android, iOS, Web, Desktop', isDark),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static Widget _buildAboutMetaRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => _showAboutDialog(context, isDark),
            tooltip: 'About Campusly',
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
                      // Profile Header Card
                      _buildProfileCard(context, isDark),

                      const SizedBox(height: 24),

                      // Academic Statistics Grid
                      SectionHeader(
                        title: 'Academic Performance',
                        subtitle: 'Cumulative university credentials',
                        icon: Icons.school_outlined,
                      ),
                      const SizedBox(height: 8),
                      _buildAcademicStats(context, appState, isDark),

                      const SizedBox(height: 24),

                      // Student Achievements Section
                      SectionHeader(
                        title: 'Honors & Achievements',
                        subtitle: 'Extracurricular & academic accolades',
                        icon: Icons.military_tech_outlined,
                      ),
                      const SizedBox(height: 8),
                      _buildAchievementsList(isDark),

                      const SizedBox(height: 24),

                      // Application Preferences & Settings
                      SectionHeader(
                        title: 'Preferences & Settings',
                        subtitle: 'Configure your app experience',
                        icon: Icons.tune_rounded,
                      ),
                      const SizedBox(height: 8),
                      _buildSettingsSection(context, appState, isDark),

                      const SizedBox(height: 24),

                      // App Version & Credits Footer
                      Center(
                        child: Column(
                          children: [
                            const CampuslyLogoWidget(size: 38, showText: false),
                            const SizedBox(height: 8),
                            Text(
                              '${AppConstants.appName} • ${AppConstants.appVersion}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Designed for 100-Mark Academic Flutter Lab Evaluation',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),
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

  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Student Avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                width: 2.5,
              ),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/student_avatar.png',
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),

          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        AppConstants.studentName,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  AppConstants.studentId,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.studentMajor,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${AppConstants.studentYear} • ${AppConstants.universityName}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textMutedLight : AppColors.textSecondaryLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicStats(BuildContext context, AppState appState, bool isDark) {
    final stats = [
      {'label': 'Cumulative GPA', 'value': '3.84', 'sub': 'Out of 4.00', 'color': AppColors.primary},
      {'label': 'Attendance', 'value': appState.overallAttendanceFormatted, 'sub': 'Good Standing', 'color': AppColors.success},
      {'label': 'Current Credits', 'value': '24', 'sub': 'Spring 2026', 'color': AppColors.secondary},
      {'label': 'Pending Tasks', 'value': '${appState.pendingAssignmentsCount}', 'sub': 'Deliverables', 'color': AppColors.warning},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final item = stats[index];
        final color = item['color'] as Color;

        return CustomCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['label'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item['sub'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
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

  Widget _buildAchievementsList(bool isDark) {
    return Column(
      children: MockData.studentAchievements.map((item) {
        final color = item['color'] as Color;
        final icon = item['icon'] as IconData;

        return CustomCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.emoji_events_outlined,
                size: 18,
                color: isDark ? AppColors.textMutedLight : AppColors.borderLight,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSettingsSection(BuildContext context, AppState appState, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Dark Mode Switch
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              appState.isDarkMode ? 'Night theme enabled' : 'Light theme enabled',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                appState.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
                size: 20,
              ),
            ),
            value: appState.isDarkMode,
            activeColor: AppColors.primary,
            onChanged: (val) {
              appState.toggleTheme(val);
            },
          ),

          const Divider(),

          // Notifications Switch
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Campus Notifications',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              appState.notificationsEnabled ? 'Alerts active' : 'Muted',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentCyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                color: AppColors.accentCyan,
                size: 20,
              ),
            ),
            value: appState.notificationsEnabled,
            activeColor: AppColors.primary,
            onChanged: (val) {
              appState.toggleNotifications(val);
            },
          ),

          const Divider(),

          // About Dialog Trigger
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'About Campusly',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              AppConstants.appVersion,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.secondary,
                size: 20,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: () => _showAboutDialog(context, isDark),
          ),
        ],
      ),
    );
  }
}
