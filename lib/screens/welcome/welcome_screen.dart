import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/campusly_logo_widget.dart';
import '../../widgets/primary_button.dart';

/// Screen 1: Splash & Welcome Screen with subtle entrance animation and Get Started navigation
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToMain() {
    Navigator.of(context).pushReplacementNamed(AppConstants.routeMain);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 40,
                  maxWidth: 600,
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),

                          // Top Branding Logo
                          const CampuslyLogoWidget(
                            size: 64,
                            showText: true,
                          ),

                          const SizedBox(height: 32),

                          // Hero Illustration Graphic using Stack, Container, Image, Icons
                          _buildHeroGraphic(size, isDark),

                          const SizedBox(height: 36),

                          // Value Proposition Text
                          Column(
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.8,
                                    color: isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                                  ),
                                  children: [
                                    const TextSpan(text: 'Smarter Campus Life\nStarts With '),
                                    TextSpan(
                                      text: 'Campusly',
                                      style: TextStyle(
                                        color: isDark
                                            ? AppColors.primaryAccentDark
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppConstants.appTagline,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Effortlessly organize your weekly classes, track attendance metrics, register for exciting campus events, and manage assignment deadlines in one sleek hub.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: isDark
                                        ? AppColors.textMutedLight
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 36),

                          // Key Feature Highlights (Wrap with 3 pills)
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildPill(Icons.calendar_month, 'Timetable', isDark),
                              _buildPill(Icons.pie_chart_outline, 'Attendance', isDark),
                              _buildPill(Icons.event_available, 'Events', isDark),
                            ],
                          ),

                          const SizedBox(height: 36),

                          // Get Started Button
                          PrimaryButton(
                            label: 'Get Started • Explore Campusly',
                            icon: Icons.arrow_forward_rounded,
                            width: double.infinity,
                            onPressed: _navigateToMain,
                          ),
                          const SizedBox(height: 12),

                          Text(
                            AppConstants.appVersion,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeroGraphic(Size size, bool isDark) {
    final graphicWidth = (size.width * 0.78).clamp(240.0, 320.0);

    return Container(
      width: graphicWidth,
      height: graphicWidth * 0.85,
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Asset Image
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/campus_banner.png',
                width: graphicWidth,
                height: graphicWidth * 0.85,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          // Central Student Graphic Card with Stack
          Positioned(
            top: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Campus Productivity 2026',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Center Graphic Icon
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 54,
              color: Colors.white,
            ),
          ),

          // Floating Chip 1 (Bottom Left)
          Positioned(
            bottom: 20,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: AppColors.success, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '87.5% Attendance',
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Chip 2 (Bottom Right)
          Positioned(
            bottom: 20,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.alarm, color: AppColors.warning, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Next: CS301',
                    style: TextStyle(
                      color: AppColors.textPrimaryLight,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.softLavender,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isDark ? AppColors.primaryAccentDark : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
