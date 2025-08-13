import 'package:intl/intl.dart';

class User {
  final String name;
  final bool isCoach;
  const User(this.name, {this.isCoach = false});

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}

class Run {
  final String id;
  final String title;
  final String city;
  final String location;
  final double distanceKm;
  final String paceMinPerKm;
  final DateTime dateTime;
  final List<User> participants;

  Run({
    required this.id,
    required this.title,
    required this.city,
    required this.location,
    required this.distanceKm,
    required this.paceMinPerKm,
    required this.dateTime,
    required this.participants,
  });

  String get dateLabel => DateFormat('EEE, d MMM').format(dateTime);
  String get timeLabel => DateFormat('h:mm a').format(dateTime);
}

class Post {
  final User author;
  final String text;
  final String timeAgo;
  const Post({required this.author, required this.text, required this.timeAgo});
}

final demoRuns = <Run>[
  Run(
    id: 'r1',
    title: 'Sunrise 5K',
    city: 'Riyadh',
    location: 'Kingdom Park Gate 3',
    distanceKm: 5,
    paceMinPerKm: '5:30',
    dateTime: DateTime(DateTime.now().year, 11, 12, 6, 0),
    participants: [
      const User('Aisha Al Harbi'),
      const User('Omar Khan'),
      const User('Lina M'),
      const User('You'),
    ],
  ),
  Run(
    id: 'r2',
    title: 'Corniche 10K',
    city: 'Jeddah',
    location: 'Corniche Plaza',
    distanceKm: 10,
    paceMinPerKm: '5:45',
    dateTime: DateTime(DateTime.now().year, 11, 15, 19, 0),
    participants: [
      const User('Rami S'),
      const User('Sara B'),
      const User('Hassan'),
    ],
  ),
  Run(
    id: 'r3',
    title: 'Trail Fun Run',
    city: 'Abha',
    location: 'Al Soudah Trailhead',
    distanceKm: 8,
    paceMinPerKm: '6:10',
    dateTime: DateTime(DateTime.now().year, 11, 23, 5, 30),
    participants: [
      const User('Maya'),
      const User('Noura'),
      const User('Ali'),
    ],
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

