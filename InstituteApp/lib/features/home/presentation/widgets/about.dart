import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final List<Map<String, String>> leads = [
    {
      'name': 'Gaurav Kushwaha',
      'image':
          'https://github.com/Gaurav-Kushwaha-1225/Gaurav-Kushwaha-1225/raw/main/IMG20231002114533.jpg',
    },
    {
      'name': 'Shubh Sahu',
      'image':
          'https://raw.githubusercontent.com/shubhxtech/addplayer/refs/heads/main/Screenshot%202025-02-13%20200538.png',
    },
    {
      'name': 'Abhijeet Jha',
      'image':
          'https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/AbhijeetJha.jpg',
    },
  ];

  final List<Map<String, String>> members = [
    {
      'name': 'Aman Gupta',
      'image':
          'https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/profilePicAman.jpg',
    },
    {
      'name': 'Utkarsh Sahu',
      'image': 'https://github.com/Utkarsh-1-Sahu/Image/raw/main/Utk.jpg',
    },
    {
      'name': 'Anshika Goel',
      'image': 'https://github.com/anshika476/Assests/raw/main/anshika.png',
    },
    {
      'name': 'Harsh Yadav',
      'image':
          'https://github.com/Aman071106/IITApp/raw/main2/ContributorImages/profilePicHarsh.jpg',
    },
    {
      'name': 'Naman Bhatia',
      'image':
          'https://github.com/naman-bhatia-2006/project-1/raw/main/gitphoto.jpg',
    },
    {
      'name': 'Dhanad',
      'image':
          'https://github.com/Blackcoat123/My-Photo/raw/main/dhanad.jpg',
    },
    {
      'name': 'Shivam Soni',
      'image':
          'https://github.com/RandomYapper/Assests/raw/main/self_photo.jpg',
    },
    {
      'name': 'Shubham Khandelwal',
      'image':
          'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-user-circle-icon.png',
    },
  ];

  Widget _avatar(BuildContext context, String name, String imageUrl,
      {double radius = 34}) {
    final color = Theme.of(context).primaryColor;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (ctx, provider) => CircleAvatar(
        radius: radius,
        backgroundImage: provider,
      ),
      placeholder: (ctx, url) => CircleAvatar(
        radius: radius,
        backgroundColor: color.withAlpha(30),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: radius * 0.6),
        ),
      ),
      errorWidget: (ctx, url, err) => CircleAvatar(
        radius: radius,
        backgroundColor: color.withAlpha(30),
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: radius * 0.6),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
        ],
      ),
    );
  }

  Widget _leadCard(BuildContext context, Map<String, String> person) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(20),
        ),
      ),
      child: Row(
        children: [
          _avatar(context, person['name']!, person['image']!, radius: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              person['name']!,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberChip(BuildContext context, Map<String, String> person) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withAlpha(18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _avatar(context, person['name']!, person['image']!, radius: 18),
          const SizedBox(width: 8),
          Text(
            person['name']!,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text('About', style: theme.textTheme.bodyMedium),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, primaryColor.withAlpha(180)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(40),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Kamand Prompt Programming Club',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Vertex',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'IIT Mandi\'s official campus companion app — mess menus, events, buy & sell, lost & found, and more, all in one place.',
                    style: TextStyle(
                      color: Colors.white.withAlpha(210),
                      fontSize: 13.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Project Leads ────────────────────────────────
                  _sectionLabel(context, 'Project Leads'),
                  Column(
                    children: leads
                        .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _leadCard(context, p),
                            ))
                        .toList(),
                  ),

                  const SizedBox(height: 28),

                  // ── Team Members ─────────────────────────────────
                  _sectionLabel(context, 'Team Members'),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        members.map((p) => _memberChip(context, p)).toList(),
                  ),

                  const SizedBox(height: 32),

                  // ── Footer note ──────────────────────────────────
                  Center(
                    child: Text(
                      'Built with ❤️ at IIT Mandi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha(100),
                        fontSize: 12,
                      ),
                    ),
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
