import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/presentation/providers/dynamic_content_provider.dart';
import 'package:vertex/features/home/presentation/widgets/dashboard_card.dart';

class Dashboard extends StatefulWidget {
  final bool isGuest;
  final UserEntity? user;

  const Dashboard({super.key, required this.isGuest, required this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentImage = 0;
  @override
  void initState() {
    super.initState();
    // Ensure content is fetched. This might be redundant if called in main, 
    // but safe to ensure data availability.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DynamicContentProvider>(context, listen: false).fetchAllContent();
    });
  }



  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items = [
      {
        "title": 'Lost/Found',
        "icon": Icons.card_travel,
        'path': UhlLinkRoutesNames.lostFoundPage,
        'extra': {
          "isGuest": widget.isGuest,
          "user": widget.user, // Handle null user
        }
      },
      {
        "title": 'Buy/Sell',
        "icon": Icons.shopping_cart_outlined,
        "path": UhlLinkRoutesNames.buySellPage,
        'extra': {
          "isGuest": widget.isGuest,
          "user": widget.user,
        }
      },
      {
        "title": 'Maps',
        "icon": Icons.map_outlined,
        "path": UhlLinkRoutesNames.campusMapPage,
        'extra': {}
      },
      {
        "title": 'Calendar',
        "icon": Icons.calendar_today_outlined,
        "path": UhlLinkRoutesNames.academicCalenderPage,
        'extra': {}
      },
      {
        "title": 'Events',
        "icon": Icons.menu,
        "path": UhlLinkRoutesNames.events,
        'extra': {
          "isGuest": widget.isGuest,
          "user": widget.user, // Handle null user
        }
      },
      {
        "title": 'Mess Menu',
        "icon": Icons.restaurant,
        "path": UhlLinkRoutesNames.messMenuPage,
        'extra': {}
      },
      {
        "title": 'Cafeteria',
        "icon": Icons.local_cafe,
        "path": UhlLinkRoutesNames.cafeteria,
        'extra': {}
      },
      {
        "title": 'Quick Links',
        "icon": Icons.link_rounded,
        "path": UhlLinkRoutesNames.quickLinksPage,
        'extra': {},
      }
    ];
    final screenSize = MediaQuery.of(context).size;
    
    // Consuming provider
    return Consumer<DynamicContentProvider>(
      builder: (context, provider, child) {
        // Merge static image with server images
        List<String> displayImages = [
          "https://iitmandi.ac.in/images/slider/slider5.jpg", // Static image
          ...provider.carouselImages.map((e) => e.imageUrl).toList(),
        ];

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          primary: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // Creative 3D Carousel with Parallax
              SizedBox(
                height: 220,
                child: CarouselSlider.builder(
                  itemCount: displayImages.length,
                  itemBuilder: (context, index, realIndex) {
                    // Safety check for range
                    if (index < 0 || index >= displayImages.length) {
                      return const SizedBox.shrink();
                    }
                    
                    return AnimatedBuilder(
                      animation: AlwaysStoppedAnimation(currentImage),
                      builder: (context, child) {
                        // Calculate distance from center for parallax effect
                        double diff = (index - currentImage).toDouble();
                        double scale = 1 - (diff.abs() * 0.15).clamp(0.0, 0.3);
                        double opacity = 1 - (diff.abs() * 0.4).clamp(0.0, 0.7);
                        
                        return Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Image
                                    CachedNetworkImage(
                                      imageUrl: displayImages[index],
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder: (context, url, progress) =>
                                          Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      errorWidget: (context, object, stacktrace) {
                                        return Container(
                                          color: Theme.of(context).cardColor.withOpacity(0.3),
                                          child: Icon(Icons.error_outline_rounded,
                                              size: 40, color: Theme.of(context).primaryColor),
                                        );
                                      },
                                    ),
                                    // Gradient overlay for depth
                                    Positioned.fill(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.5),
                                            ],
                                            stops: const [0.5, 1.0],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Shine effect on active card
                                    if (index == currentImage)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withOpacity(0.2),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  options: CarouselOptions(
                    height: 220,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.95,
                    aspectRatio: 16 / 9,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                    autoPlayCurve: Curves.easeInOutCubic,
                    onPageChanged: (value, _) {
                      setState(() {
                        currentImage = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Modern animated indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  displayImages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: currentImage == index ? 32 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: currentImage == index
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Quick Access",
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.count(
              crossAxisCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              primary: false,
              childAspectRatio: 0.75,
            children: [
              for (int i = 0; i < items.length; i++)
                DashboardCard(
                  title: items[i]['title'],
                  icon: items[i]['icon'],
                  onTap: () {
                    if (items[i]['extra'] != null &&
                        items[i]['extra'].isNotEmpty) {
                      GoRouter.of(context).pushNamed(
                        items[i]['path'],
                        extra: items[i]['extra'],
                      );
                    } else {
                      GoRouter.of(context).pushNamed(items[i]['path']);
                    }
                  },
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
      },
    );
  }
}
