import 'package:flutter/material.dart';

import 'data/sample_events.dart';
import 'models/event.dart';

const Color backgroundColor = Color(0xFF101014);
const Color surfaceColor = Color(0xFF1B1B23);
const Color accentColor = Color(0xFFB69CFF);
const Color secondaryTextColor = Color(0xFFAAA7B5);

void main() {
  runApp(const EventraApp());
}

class EventraApp extends StatelessWidget {
  const EventraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventra',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.dark(
          primary: accentColor,
          onPrimary: Color(0xFF201638),
          surface: surfaceColor,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          surfaceTintColor: Colors.transparent,
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: surfaceColor,
          indicatorColor: Color(0xFF3A3150),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      ),
      home: const EventraHome(),
    );
  }
}

// MAIN NAVIGATION

class EventraHome extends StatefulWidget {
  const EventraHome({super.key});

  @override
  State<EventraHome> createState() => _EventraHomeState();
}

class _EventraHomeState extends State<EventraHome> {
  int selectedIndex = 0;

  String searchQuery = '';
  String selectedCategory = 'All';

  final Set<String> favorites = {};

  final List<String> categories = [
    'All',
    'Music',
    'Technology',
    'Sports',
    'Art',
    'Gaming',
    'Food',
  ];

  List<Event> get filteredEvents {
    return sampleEvents.where((event) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          event.title.toLowerCase().contains(query) ||
          event.category.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);

      final matchesCategory =
          selectedCategory == 'All' || event.category == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
  }

  void toggleFavorite(String eventId) {
    setState(() {
      if (favorites.contains(eventId)) {
        favorites.remove(eventId);
      } else {
        favorites.add(eventId);
      }
    });
  }

  void openEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsScreen(
          event: event,
          isFavorite: favorites.contains(event.id),
          onFavoriteTap: () => toggleFavorite(event.id),
        ),
      ),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final savedEvents = sampleEvents
        .where((event) => favorites.contains(event.id))
        .toList();

    final pages = [
      HomeScreen(
        events: filteredEvents,
        categories: categories,
        selectedCategory: selectedCategory,
        onCategoryChanged: (value) {
          setState(() => selectedCategory = value);
        },
        onSearchChanged: (value) {
          setState(() => searchQuery = value);
        },
        onEventTap: openEvent,
        favorites: favorites,
        onFavoriteTap: toggleFavorite,
      ),
      ExploreScreen(
        events: filteredEvents,
        categories: categories,
        selectedCategory: selectedCategory,
        onCategoryChanged: (value) {
          setState(() => selectedCategory = value);
        },
        onSearchChanged: (value) {
          setState(() => searchQuery = value);
        },
        onEventTap: openEvent,
        favorites: favorites,
        onFavoriteTap: toggleFavorite,
      ),
      SavedScreen(
        events: savedEvents,
        onEventTap: openEvent,
        favorites: favorites,
        onFavoriteTap: toggleFavorite,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// REUSABLE SEARCH FIELD

class EventSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EventSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search events, categories, locations...',
        hintStyle: const TextStyle(color: secondaryTextColor),
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 17),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// REUSABLE CATEGORY FILTER

class CategoryFilters extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onChanged;

  const CategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category == selectedCategory;

          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) => onChanged(category),
            selectedColor: accentColor,
            backgroundColor: surfaceColor,
            labelStyle: TextStyle(
              color: selected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide.none,
          );
        },
      ),
    );
  }
}

// HOME SCREEN

class HomeScreen extends StatelessWidget {
  final List<Event> events;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Event> onEventTap;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteTap;

  const HomeScreen({
    super.key,
    required this.events,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    required this.onEventTap,
    required this.favorites,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final featuredEvent = sampleEvents.first;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVENTRA',
                    style: TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Discover experiences.',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded),
              tooltip: 'Notifications',
            ),
          ],
        ),

        const SizedBox(height: 25),

        EventSearchField(onChanged: onSearchChanged),

        const SizedBox(height: 27),

        const SectionHeading(title: 'Featured event'),

        const SizedBox(height: 13),

        FeaturedEventCard(
          event: featuredEvent,
          onTap: () => onEventTap(featuredEvent),
        ),

        const SizedBox(height: 28),

        const SectionHeading(title: 'Explore categories'),

        const SizedBox(height: 13),

        CategoryFilters(
          categories: categories,
          selectedCategory: selectedCategory,
          onChanged: onCategoryChanged,
        ),

        const SizedBox(height: 28),

        SectionHeading(
          title: 'Upcoming events',
          trailing: ' ${events.length} found',
        ),

        const SizedBox(height: 14),

        if (events.isEmpty)
          const EmptyState(
            message: 'No events found. Try another search or category.',
          )
        else
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EventCard(
                event: event,
                isFavorite: favorites.contains(event.id),
                onTap: () => onEventTap(event),
                onFavoriteTap: () => onFavoriteTap(event.id),
              ),
            ),
          ),
      ],
    );
  }
}

// EXPLORE SCREEN

class ExploreScreen extends StatelessWidget {
  final List<Event> events;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<Event> onEventTap;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteTap;

  const ExploreScreen({
    super.key,
    required this.events,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onSearchChanged,
    required this.onEventTap,
    required this.favorites,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Explore',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 7),
        const Text(
          'Find something worth experiencing.',
          style: TextStyle(color: secondaryTextColor),
        ),
        const SizedBox(height: 23),

        EventSearchField(onChanged: onSearchChanged),

        const SizedBox(height: 20),

        CategoryFilters(
          categories: categories,
          selectedCategory: selectedCategory,
          onChanged: onCategoryChanged,
        ),

        const SizedBox(height: 25),

        SectionHeading(
          title: 'All events',
          trailing: ' ${events.length} found',
        ),

        const SizedBox(height: 15),

        if (events.isEmpty)
          const EmptyState(
            message: 'No matching events. Try changing your filters.',
          )
        else
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EventCard(
                event: event,
                isFavorite: favorites.contains(event.id),
                onTap: () => onEventTap(event),
                onFavoriteTap: () => onFavoriteTap(event.id),
              ),
            ),
          ),
      ],
    );
  }
}

// SAVED SCREEN

class SavedScreen extends StatelessWidget {
  final List<Event> events;
  final ValueChanged<Event> onEventTap;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteTap;

  const SavedScreen({
    super.key,
    required this.events,
    required this.onEventTap,
    required this.favorites,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Saved events',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your personal collection of experiences.',
          style: TextStyle(color: secondaryTextColor),
        ),
        const SizedBox(height: 25),

        if (events.isEmpty)
          const EmptyState(
            icon: Icons.bookmark_border_rounded,
            message: 'No saved events yet. Explore and bookmark events.',
          )
        else
          ...events.map(
            (event) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: EventCard(
                event: event,
                isFavorite: favorites.contains(event.id),
                onTap: () => onEventTap(event),
                onFavoriteTap: () => onFavoriteTap(event.id),
              ),
            ),
          ),
      ],
    );
  }
}

// PROFILE SCREEN

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Profile',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 35),
        const Center(
          child: CircleAvatar(
            radius: 43,
            backgroundColor: Color(0xFF3A3150),
            child: Icon(Icons.person_rounded, size: 45, color: accentColor),
          ),
        ),
        const SizedBox(height: 17),
        const Center(
          child: Text(
            'Eventra User',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 7),
        const Center(
          child: Text(
            'Welcome to Eventra',
            style: TextStyle(color: secondaryTextColor),
          ),
        ),
        const SizedBox(height: 35),
        const ProfileOption(
          icon: Icons.confirmation_number_outlined,
          title: 'My bookings',
        ),
        const ProfileOption(
          icon: Icons.person_outline,
          title: 'Personal information',
        ),
        const ProfileOption(icon: Icons.settings_outlined, title: 'Settings'),
        const ProfileOption(
          icon: Icons.help_outline,
          title: 'Help and support',
        ),
      ],
    );
  }
}

// REUSABLE PROFILE OPTION

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;

  const ProfileOption({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: Icon(icon, color: accentColor),
      title: Text(title),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: secondaryTextColor,
      ),
      onTap: () {},
    );
  }
}

// SECTION HEADING

class SectionHeading extends StatelessWidget {
  final String title;
  final String? trailing;

  const SectionHeading({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(color: secondaryTextColor, fontSize: 12),
          ),
      ],
    );
  }
}

// FEATURED EVENT

class FeaturedEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const FeaturedEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              EventImage(event: event),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xE6000000)],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.category.toUpperCase(),
                      style: const TextStyle(
                        color: accentColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${event.date}  •  ${event.location}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// EVENT CARD

class EventCard extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const EventCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 165,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  EventImage(event: event),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Material(
                      color: Colors.black54,
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: onFavoriteTap,
                        tooltip: isFavorite
                            ? 'Remove from saved events'
                            : 'Save event',
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.pinkAccent : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        event.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: accentColor,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          event.date,
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        event.price,
                        style: const TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// REUSABLE EVENT IMAGE WITH FALLBACK

class EventImage extends StatelessWidget {
  final Event event;

  const EventImage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      event.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: event.accentColor.withValues(alpha: 0.2),
          child: Center(
            child: Icon(
              Icons.event_rounded,
              color: event.accentColor,
              size: 55,
            ),
          ),
        );
      },
    );
  }
}

// EVENT DETAILS SCREEN

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const EventDetailsScreen({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 270,
            pinned: true,
            backgroundColor: backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: EventImage(event: event),
            ),
            actions: [
              IconButton(
                onPressed: onFavoriteTap,
                tooltip: isFavorite ? 'Saved' : 'Save event',
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.pinkAccent : Colors.white,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.category.toUpperCase(),
                    style: const TextStyle(
                      color: accentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 22),
                  DetailRow(
                    icon: Icons.calendar_today_outlined,
                    text: event.date,
                  ),
                  const SizedBox(height: 15),
                  DetailRow(
                    icon: Icons.location_on_outlined,
                    text: event.location,
                  ),
                  const SizedBox(height: 15),
                  DetailRow(
                    icon: Icons.confirmation_number_outlined,
                    text: event.price,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'About this event',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: secondaryTextColor,
                      height: 1.7,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Booking will be implemented in the next increment.',
                            ),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 17),
                      ),
                      child: const Text(
                        'Book tickets',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// EVENT DETAIL ROW

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const DetailRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 20),
        const SizedBox(width: 13),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

// EMPTY STATE

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.search_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 15),
      child: Column(
        children: [
          Icon(icon, size: 48, color: secondaryTextColor),
          const SizedBox(height: 15),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: secondaryTextColor, height: 1.5),
          ),
        ],
      ),
    );
  }
}
