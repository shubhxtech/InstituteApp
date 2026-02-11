import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/presentation/pages/academics.dart';
import 'package:vertex/features/home/presentation/pages/dashboard.dart';
import 'package:vertex/features/home/presentation/pages/feeds.dart';
import 'package:vertex/features/home/presentation/pages/profile.dart';
import 'package:vertex/features/home/presentation/pages/job_portal.dart';

import '../../../../config/routes/routes_consts.dart';
import '../../../../widgets/glass_container.dart';

class HomePage extends StatefulWidget {
  final bool isGuest;
  final UserEntity? user;
  const HomePage({super.key, required this.isGuest, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentBottomBarIndex = 0;

  final homePageTitles = [
    "Dashboard",
    "Feeds",
    "Academics",
    "Job Portal",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> homePages = [
      Dashboard(isGuest: widget.isGuest, user: widget.user),
      FeedPage(isGuest: widget.isGuest, user: widget.user),
      Academics(isGuest: widget.isGuest, user: widget.user),
      JobPortalPage(isGuest: widget.isGuest),
      Profile(isGuest: widget.isGuest, user: widget.user),
    ];
    return Scaffold(
      extendBody: true, 
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          homePageTitles[currentBottomBarIndex],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              GoRouter.of(context).pushNamed(UhlLinkRoutesNames.notifications,
                  extra: {
                    'isGuest': widget.isGuest,
                    'user': widget.user,
                  });
            },
          ),
        ],
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: homePages[currentBottomBarIndex],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E).withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    currentBottomBarIndex = index;
                  });
                },
                elevation: 0,
                currentIndex: currentBottomBarIndex,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: const Color(0xFF0A84FF),
                unselectedItemColor: const Color(0xFF8E8E93),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedIconTheme: const IconThemeData(
                  size: 28,
                  color: Color(0xFF0A84FF),
                ),
                unselectedIconTheme: const IconThemeData(
                  size: 24,
                  color: Color(0xFF8E8E93),
                ),
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.dashboard_rounded), label: "Dashboard"),
                  BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.school_rounded), label: "Academics"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.work_outline_rounded), label: "Job Portal"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_rounded), label: "Profile"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
