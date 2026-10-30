import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../models/event_model.dart';
import '../../state/app_state.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/primary_button.dart';

/// Screen 6: Event Details with interactive RSVP registration and Hero image animation
class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final String? heroTag;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final eventIndex = appState.events.indexWhere((e) => e.id == eventId);
    if (eventIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Details')),
        body: const Center(child: Text('Event not found.')),
      );
    }

    final event = appState.events[eventIndex];

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Collapsible SliverAppBar with Hero Banner
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withValues(alpha: 0.4),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Back',
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withValues(alpha: 0.4),
                  child: IconButton(
                    icon: const Icon(Icons.share_outlined, color: Colors.white, size: 18),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing link for "${event.title}" copied!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    tooltip: 'Share',
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroBanner(event),
            ),
          ),

          // Event Content Body
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag & Capacity
                      SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: event.primaryColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: event.primaryColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                event.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: event.primaryColor,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDarkElevated : AppColors.softLavender,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${event.capacity - event.registeredCount} Seats Remaining',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Event Title
                      Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          height: 1.25,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Key Event Logistics Cards
                      _buildLogisticsCard(event, isDark),

                      const SizedBox(height: 24),

                      // Attendance Capacity Progress Indicator
                      _buildCapacityCard(event, isDark),

                      const SizedBox(height: 24),

                      // Description Section
                      Text(
                        'About This Event',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Organizer Card
                      _buildOrganizerCard(event, isDark),

                      const SizedBox(height: 36),

                      // Register / RSVP Action Button
                      PrimaryButton(
                        label: event.isRegistered ? 'Cancel Registration' : 'Register for Event (Free RSVP)',
                        icon: event.isRegistered ? Icons.cancel_outlined : Icons.check_circle_outline,
                        isSecondary: event.isRegistered,
                        width: double.infinity,
                        onPressed: () {
                          final newStatus = appState.toggleEventRegistration(event.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                newStatus
                                    ? 'Registration Confirmed for "${event.title}"! 🎉'
                                    : 'RSVP Cancelled for "${event.title}".',
                              ),
                              backgroundColor: newStatus ? AppColors.success : AppColors.textSecondaryLight,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(EventModel event) {
    return Hero(
      tag: heroTag ?? 'event_${event.id}',
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [event.primaryColor, event.secondaryColor],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Asset Image
            if (event.bannerAsset != null)
              Opacity(
                opacity: 0.25,
                child: Image.asset(
                  event.bannerAsset!,
                  fit: BoxFit.cover,
                ),
              ),

            // Large watermark icon
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                event.icon,
                size: 180,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),

            // Bottom gradient overlay for readability
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.6),
                    ],
                  ),
                ),
              ),
            ),

            // Event icon pill on bottom left
            Positioned(
              left: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: Icon(event.icon, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogisticsCard(EventModel event, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: event.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.calendar_month_rounded, color: event.primaryColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date & Time',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${event.date} • ${event.time}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.secondary, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Campus Venue',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.venue,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityCard(EventModel event, bool isDark) {
    final progress = (event.registeredCount / event.capacity).clamp(0.0, 1.0);

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Registration Capacity',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progress * 100).toInt()}% Filled',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: event.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.surfaceDarkElevated : AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(event.primaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${event.registeredCount} out of ${event.capacity} seats reserved.',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizerCard(EventModel event, bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: event.secondaryColor.withValues(alpha: 0.15),
            child: Icon(Icons.corporate_fare_rounded, color: event.secondaryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Organized By',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.organizer,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
