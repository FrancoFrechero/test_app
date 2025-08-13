import 'package:flutter/material.dart';

void main() => runApp(const StrideClubApp());

class StrideClubApp extends StatelessWidget {
  const StrideClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StrideClub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
        fontFamily: 'SF Pro',
      ),
      home: const RootScaffold(),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});
  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _idx = 0;
  final _pages = const [RunsPage(), FeedPage(), TipsPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_idx],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.directions_run_outlined),
            selectedIcon: Icon(Icons.directions_run),
            label: 'Runs',
          ),
          NavigationDestination(
            icon: Icon(Icons.dynamic_feed_outlined),
            selectedIcon: Icon(Icons.dynamic_feed),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Tips',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// -------------------- Runs (Home) --------------------

class RunsPage extends StatelessWidget {
  const RunsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          snap: true,
          title: Text('Upcoming Runs'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemCount: demoRuns.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => RunCard(run: demoRuns[i]),
          ),
        ),
      ],
    );
  }
}

class RunCard extends StatelessWidget {
  final Run run;
  const RunCard({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Hero(
      tag: 'run_${run.id}',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RunDetails(run: run)),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [cs.primaryContainer, cs.secondaryContainer],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.route, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        run.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${run.city} • ${run.dateLabel}',
                        style: TextStyle(
                          color: cs.onPrimaryContainer.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 16, color: cs.primary),
                          const SizedBox(width: 6),
                          Text(run.timeLabel),
                          const SizedBox(width: 12),
                          Icon(Icons.straighten, size: 16, color: cs.primary),
                          const SizedBox(width: 6),
                          Text('${run.distanceKm} km'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RunDetails extends StatefulWidget {
  final Run run;
  const RunDetails({super.key, required this.run});

  @override
  State<RunDetails> createState() => _RunDetailsState();
}

class _RunDetailsState extends State<RunDetails> {
  bool joined = false;

  @override
  Widget build(BuildContext context) {
    final run = widget.run;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 220,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(run.title),
              background: Hero(
                tag: 'run_${run.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.directions_run,
                      size: 96,
                      color: cs.onPrimary.withOpacity(0.85),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Tile(
                    icon: Icons.place,
                    label: 'Meeting point',
                    value: run.location,
                  ),
                  _Tile(
                    icon: Icons.schedule,
                    label: 'Time',
                    value: '${run.dateLabel} • ${run.timeLabel}',
                  ),
                  _Tile(
                    icon: Icons.straighten,
                    label: 'Distance',
                    value:
                        '${run.distanceKm} km • Pace ${run.paceMinPerKm} min/km',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Participants',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: run.participants
                        .map(
                          (p) =>
                              CircleAvatar(radius: 18, child: Text(p.initials)),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text('Map preview (placeholder)'),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: () {
              setState(() => joined = !joined);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    joined
                        ? 'You joined ${run.title} 🎉'
                        : 'You left ${run.title}',
                  ),
                ),
              );
            },
            icon: Icon(joined ? Icons.check : Icons.add),
            label: Text(joined ? 'Joined' : 'Join Run'),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _Tile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: cs.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

/// -------------------- Feed --------------------

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Club Feed')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: demoPosts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final post = demoPosts[i];
          return Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text(post.author.initials)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.author.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            post.timeAgo,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(post.text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.thumb_up_alt_outlined),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.mode_comment_outlined),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// -------------------- Tips --------------------

class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: true,
          snap: true,
          title: Text('Running Tips'),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.separated(
            itemBuilder: (context, i) {
              final tip = demoTips[i];
              return ListTile(
                title: Text(tip.title),
                subtitle: Text('${tip.category} • ${tip.description}'),
                tileColor: Theme.of(context).colorScheme.surfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: demoTips.length,
          ),
        ),
      ],
    );
  }
}

/// -------------------- Profile --------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: cs.primaryContainer,
              child: const Text('FF', style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(height: 12),
            const Text(
              'Franco Frechero',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            Text(
              'Riyadh Running Club',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _Stat(label: 'Runs', value: '24'),
                _Stat(label: 'KM', value: '182'),
                _Stat(label: 'Pace', value: '5:12'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: cs.onSurfaceVariant)),
      ],
    );
  }
}

/// -------------------- Demo data --------------------

class Run {
  final String id, title, city, dateLabel, timeLabel, location, paceMinPerKm;
  final double distanceKm;
  final List<User> participants;
  Run({
    required this.id,
    required this.title,
    required this.city,
    required this.dateLabel,
    required this.timeLabel,
    required this.location,
    required this.distanceKm,
    required this.paceMinPerKm,
    required this.participants,
  });
}

class User {
  final String name;
  String get initials {
    final normalized = name.trim();
    if (normalized.isEmpty) return '?';
    final parts = normalized.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  const User(this.name);
}

class Post {
  final User author;
  final String text, timeAgo;
  const Post({required this.author, required this.text, required this.timeAgo});
}

final demoRuns = <Run>[
  Run(
    id: 'r1',
    title: 'Sunrise 5K',
    city: 'Riyadh',
    dateLabel: 'Tue, 12 Nov',
    timeLabel: '6:00 AM',
    location: 'Kingdom Park Gate 3',
    distanceKm: 5,
    paceMinPerKm: '5:30',
    participants: const [
      User('Aisha Al Harbi'),
      User('Omar Khan'),
      User('Lina M'),
      User('You'),
    ],
  ),
  Run(
    id: 'r2',
    title: 'Corniche 10K',
    city: 'Jeddah',
    dateLabel: 'Fri, 15 Nov',
    timeLabel: '7:00 PM',
    location: 'Corniche Plaza',
    distanceKm: 10,
    paceMinPerKm: '5:45',
    participants: const [User('Rami S'), User('Sara B'), User('Hassan')],
  ),
  Run(
    id: 'r3',
    title: 'Trail Fun Run',
    city: 'Abha',
    dateLabel: 'Sat, 23 Nov',
    timeLabel: '5:30 AM',
    location: 'Al Soudah Trailhead',
    distanceKm: 8,
    paceMinPerKm: '6:10',
    participants: const [User('Maya'), User('Noura'), User('Ali')],
  ),
];

final demoPosts = <Post>[
  Post(
    author: const User('Aisha Al Harbi'),
    text: 'Crushed my intervals today. See you all at the Sunrise 5K! 🏃‍♀️',
    timeAgo: '2h',
  ),
  Post(
    author: const User('Omar Khan'),
    text: 'Anyone up for an easy recovery run tomorrow?',
    timeAgo: '5h',
  ),
  Post(
    author: const User('Lina M'),
    text: 'New shoes day ✨ Loving the bounce.',
    timeAgo: '1d',
  ),
];

/// -------------------- Demo tips --------------------

class Tip {
  final String title;
  final String category;
  final String description;
  const Tip({
    required this.title,
    required this.category,
    required this.description,
  });
}

final demoTips = <Tip>[
  const Tip(
    title: 'Start Slow',
    category: 'Beginner',
    description: 'Ease into runs to avoid injury.',
  ),
  const Tip(
    title: 'Fuel Right',
    category: 'Nutrition',
    description: 'Eat a balanced meal a few hours before.',
  ),
  const Tip(
    title: 'Speed Work',
    category: 'Advanced',
    description: 'Include intervals once a week to build pace.',
  ),
];
