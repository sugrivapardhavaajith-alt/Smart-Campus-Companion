import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../models/event_model.dart';
import '../../state/app_state.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/event_card.dart';
import '../../widgets/section_header.dart';
import 'event_details_screen.dart';

/// Screen 5: Campus Events Discovery with Real-Time Search and Category Filtering
class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToDetails(String eventId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(eventId: eventId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 680;

    // Filter events according to active category and search query
    final filteredEvents = appState.events.where((event) {
      final matchesCategory = _selectedCategory == 'All' ||
          event.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          event.venue.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final featuredEvent = appState.events.isNotEmpty ? appState.events.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              final rsvpCount = appState.events.where((e) => e.isRegistered).length;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You have RSVP\'d to $rsvpCount upcoming campus events.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'My RSVPs',
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search TextField with Prefix and Suffix Icons
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.trim();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search hackathons, fests, workshops...',
                          prefixIcon: const Icon(Icons.search_rounded, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Category Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: AppConstants.eventCategories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Featured Event Banner (Only shown when not searching or category matches)
                      if (_searchQuery.isEmpty &&
                          featuredEvent != null &&
                          (_selectedCategory == 'All' ||
                              featuredEvent.category == _selectedCategory)) ...[
                        SectionHeader(
                          title: 'Spotlight Event',
                          subtitle: 'Handpicked university highlight',
                          icon: Icons.star_rounded,
                        ),
                        const SizedBox(height: 8),
                        _buildFeaturedBanner(context, featuredEvent, isDark),
                        const SizedBox(height: 24),
                      ],

                      // Events List / Grid Header
                      SectionHeader(
                        title: _selectedCategory == 'All'
                            ? 'All Upcoming Events'
                            : '$_selectedCategory Events',
                        subtitle: '${filteredEvents.length} events matching criteria',
                        icon: Icons.event_note_rounded,
                      ),
                      const SizedBox(height: 12),

                      // Dynamic Events Grid / List
                      if (filteredEvents.isEmpty)
                        _buildEmptySearchState(isDark)
                      else if (isTablet)
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return EventCard(
                              event: event,
                              onTap: () => _navigateToDetails(event.id),
                            );
                          },
                        )
                      else
                        ...filteredEvents.map(
                          (event) => EventCard(
                            event: event,
                            onTap: () => _navigateToDetails(event.id),
                          ),
                        ),

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

  Widget _buildFeaturedBanner(BuildContext context, EventModel event, bool isDark) {
    return CustomCard(
      onTap: () => _navigateToDetails(event.id),
      padding: EdgeInsets.zero,
      gradient: AppColors.primaryGradient,
      child: Stack(
        children: [
          // Background Asset Image overlay
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/images/campus_banner.png',
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'FEATURED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      event.date,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${event.venue} • ${event.registeredCount} Students Attending',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View & RSVP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded, size: 13, color: AppColors.primary),
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

  Widget _buildEmptySearchState(bool isDark) {
    return CustomCard(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 44,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
            ),
            const SizedBox(height: 12),
            Text(
              'No Events Match Your Search',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try clearing your search query or selecting "All" categories to discover more events.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                });
              },
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
