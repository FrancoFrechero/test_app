import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'app_state.dart';
import 'models.dart';
import 'reminder_service.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => RunClubState(ReminderService()),
        child: const RunClubApp(),
      ),
    );

class RunClubApp extends StatelessWidget {
  const RunClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RunClub',
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
  final _pages = const [RunsPage(), FeedPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<RunClubState>();
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _pages[_idx],
      ),
      floatingActionButton: _idx == 0 && state.isCoach
          ? FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateRunPage()),
              ),
              child: const Icon(Icons.add),
            )
          : null,
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
    final runs = context.watch<RunClubState>().runs;
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
            itemCount: runs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => RunCard(run: runs[i]),
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

class RunDetails extends StatelessWidget {
  final Run run;
  const RunDetails({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<RunClubState>();
    final joined = appState.isJoined(run);
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
              appState.toggleJoin(run);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    joined
                        ? 'You left ${run.title}'
                        : 'You joined ${run.title} 🎉',
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

/// -------------------- Profile --------------------

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final state = context.watch<RunClubState>();
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
            const SizedBox(height: 24),
            if (!state.isCoach)
              FilledButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CoachSignInPage(),
                  ),
                ),
                child: const Text('Coach Sign In'),
              )
            else
              Text(
                'Signed in as Coach',
                style: TextStyle(color: cs.primary),
              ),
          ],
        ),
      ),
    );
  }
}

class CoachSignInPage extends StatefulWidget {
  const CoachSignInPage({super.key});

  @override
  State<CoachSignInPage> createState() => _CoachSignInPageState();
}

class _CoachSignInPageState extends State<CoachSignInPage> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;

  void _signIn() {
    try {
      context
          .read<RunClubState>()
          .signInAsCoach(_nameController.text, _passwordController.text);
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class CreateRunPage extends StatefulWidget {
  const CreateRunPage({super.key});

  @override
  State<CreateRunPage> createState() => _CreateRunPageState();
}

class _CreateRunPageState extends State<CreateRunPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _cityController = TextEditingController();
  final _locationController = TextEditingController();
  final _distanceController = TextEditingController();
  final _paceController = TextEditingController();
  DateTime? _dateTime;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 6, minute: 0),
    );
    if (time == null) return;
    setState(() {
      _dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  void _save() {
    if (_formKey.currentState!.validate() && _dateTime != null) {
      context.read<RunClubState>().createRun(
            title: _titleController.text,
            city: _cityController.text,
            location: _locationController.text,
            distanceKm: double.tryParse(_distanceController.text) ?? 0,
            paceMinPerKm: _paceController.text,
            dateTime: _dateTime!,
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Run')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v!.isEmpty ? 'Enter title' : null,
            ),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (v) => v!.isEmpty ? 'Enter city' : null,
            ),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
              validator: (v) => v!.isEmpty ? 'Enter location' : null,
            ),
            TextFormField(
              controller: _distanceController,
              decoration: const InputDecoration(labelText: 'Distance (km)'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Enter distance' : null,
            ),
            TextFormField(
              controller: _paceController,
              decoration: const InputDecoration(labelText: 'Pace (min/km)'),
              validator: (v) => v!.isEmpty ? 'Enter pace' : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                _dateTime == null
                    ? 'Pick date & time'
                    : DateFormat('EEE, d MMM h:mm a').format(_dateTime!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _save, child: const Text('Create')),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cityController.dispose();
    _locationController.dispose();
    _distanceController.dispose();
    _paceController.dispose();
    super.dispose();
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
