import 'package:flutter/material.dart';

class Category {
  final String name;
  final String hashtag;
  final IconData icon;
  final String description;

  const Category({
    required this.name,
    required this.hashtag,
    required this.icon,
    required this.description,
  });
}

const List<Category> CATEGORIES = [
  Category(
    name: 'A Better Sri Lanka',
    hashtag: '#betterSL',
    icon: Icons.landscape,
    description:
        'Stories envisioning a prosperous and sustainable Sri Lanka, where people thrive and communities flourish.',
  ),
  Category(
    name: 'Adventure and Exploration',
    hashtag: '#travel',
    icon: Icons.explore,
    description:
        'Stories that take readers on an exciting journey of discovery and adventure, set in exotic locations around the world.',
  ),
  Category(
    name: 'Business and Entrepreneurship',
    hashtag: '#biz',
    icon: Icons.work,
    description:
        'Stories that inspire and educate readers about entrepreneurship, innovation, and business success, featuring interviews with successful entrepreneurs and tips for starting and growing a business.',
  ),
  Category(
    name: 'Comedy and Humour',
    hashtag: '#comedy',
    icon: Icons.sentiment_very_satisfied,
    description:
        'Stories that inspire readers to overcome challenges, pursue their dreams, and live a fulfilling life.',
  ),
  Category(
    name: 'Culture and Tradition',
    hashtag: '#tradition',
    icon: Icons.music_note,
    description:
        'Stories that celebrate the unique customs, beliefs, and practices of Sri Lanka and its diverse communities, exploring the rich heritage of the island.',
  ),
  Category(
    name: 'Destinations Abroad',
    hashtag: '#abroad',
    icon: Icons.flight,
    description:
        'Stories and advice from individuals who have traveled and migrated to different places, including tips for navigating the challenges of relocation and adaptation.',
  ),
  Category(
    name: 'Drama and Conflict',
    hashtag: '#drama',
    icon: Icons.theaters,
    description:
        'Intense and emotionally charged stories that explore the conflicts and tensions between individuals, communities, and cultures.',
  ),
  Category(
    name: 'Feedback',
    hashtag: '#feedback',
    icon: Icons.feedback,
    description: 'Feedback on stories and the app.',
  ),
  Category(
    name: 'Folk Tales and Legends',
    hashtag: '#folklore',
    icon: Icons.bedtime,
    description:
        'This category can include traditional stories and myths from Sri Lanka and other cultures around the world.',
  ),
  Category(
    name: 'Health and Wellness',
    hashtag: '#wellbeing',
    icon: Icons.favorite_border,
    description:
        'Information, resources, and personal stories related to physical and mental health, including tips for self-care and managing health conditions.',
  ),
  Category(
    name: 'Historical Fiction',
    hashtag: '#history',
    icon: Icons.local_florist,
    description:
        'Stories that recreate historical events, figures, and places, and explore the different perspectives and themes of the past.',
  ),
  Category(
    name: 'Life Lessons and Wisdom',
    hashtag: '#experience',
    icon: Icons.lightbulb_outline,
    description:
        'Personal experiences and insights shared by people from all walks of life, offering valuable lessons and wisdom.',
  ),
  Category(
    name: 'Love and Romance',
    hashtag: '#lovestory',
    icon: Icons.favorite,
    description:
        'Stories that explore the different facets of love, romance, and relationships, set in different contexts and situations.',
  ),
  Category(
    name: 'Mystery and Thriller',
    hashtag: '#mystery',
    icon: Icons.search,
    description:
        'Suspenseful stories that keep readers on the edge of their seats, featuring plot twists and unexpected turns.',
  ),
  Category(
    name: 'News & update',
    hashtag: '#news',
    icon: Icons.newspaper,
    description: 'News updates without limit.',
  ),
  Category(
    name: 'Science Fiction and Fantasy',
    hashtag: '#scifi',
    icon: Icons.science,
    description:
        'Stories that recreate historical events, figures, and places, and explore the different perspectives and themes of the past.',
  ),
  Category(
    name: 'Short Stories',
    hashtag: '#shortstory',
    icon: Icons.book,
    description:
        'Quick and engaging stories that can be read on-the-go, featuring compelling characters and plotlines that leave a lasting impression.',
  ),
  Category(
    name: 'Social Issues',
    hashtag: '#justice',
    icon: Icons.balance,
    description:
        'Stories that shed light on the pressing social issues affecting Sri Lanka and the world, such as poverty, inequality, discrimination, and human rights violations.',
  ),
  Category(
    name: 'Sports',
    hashtag: '#sport',
    icon: Icons.sports_cricket,
    description: 'Sport updates.',
  ),
];
