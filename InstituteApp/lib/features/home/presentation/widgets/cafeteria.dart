import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertex/features/home/presentation/providers/dynamic_content_provider.dart';
import 'package:vertex/widgets/glass_container.dart';
import 'package:vertex/config/new_app_theme.dart';
import 'package:vertex/widgets/glass_button.dart';

class CafeteriaPage extends StatefulWidget {
  const CafeteriaPage({super.key});

  @override
  State<CafeteriaPage> createState() => _CafeteriaPageState();
}

class _CafeteriaPageState extends State<CafeteriaPage> {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: Text("Cafeteria",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
            // Global Gradient Background - Ensure consistency
            Container( // Or use NewAppTheme.mainBgGradient directly if it covers full screen
              decoration: const BoxDecoration(
                  gradient: NewAppTheme.mainBgGradient
              ),
            ),
            Consumer<DynamicContentProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final items = provider.cafeterias;

              if (items.isEmpty) {
                 return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.storefront_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text("No cafeterias found", style: TextStyle(color: Colors.grey)),
                      GlassButton(
                         onPressed: () => provider.fetchAllContent(),
                         text: "Retry",
                      )
                    ],
                  ),
                 );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GlassContainer(
                    opacity: 0.1,
                    borderRadius: BorderRadius.circular(15),
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        item.images.isNotEmpty
                            ? CarouselSlider(
                                items: item.images
                                    .map((image) => Container(
                                          width: screenSize.width - 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.1),
                                              width: 1.5,
                                            ),
                                            // color: Theme.of(context).cardColor, // Remove solid color
                                          ),
                                          child: ClipRRect( // Clip image to border radius
                                            borderRadius: BorderRadius.circular(15),
                                            child: CachedNetworkImage(
                                              imageUrl: image,
                                              fit: BoxFit.cover,
                                              errorWidget: (context, string, object) {
                                                return Center(child: Icon(Icons.error, color: Colors.white));
                                              },
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                    height: screenSize.height * 0.25,
                                    autoPlay: true,
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 1,
                                    autoPlayInterval: const Duration(seconds: 15),
                                    enlargeCenterPage: true))
                            : Container(),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(item.name,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
                            const SizedBox(height: 5),
                            Text("Time: ${item.time}",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
                            Text("Contact: ${item.contact}",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
                            Text("Location: ${item.location}",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
                            Text("Delivery Time: ${item.deliveryTime}",
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GlassButton(
                          text: "View Menu",
                          width: 120, // Give it some width
                          height: 40,
                          onPressed: () {
                            if (item.menu.isNotEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: CarouselSlider(
                                        items: item.menu
                                            .map((image) => ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: image,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.white),
                                                )))
                                            .toList(),
                                        options: CarouselOptions(
                                          height: screenSize.height * 0.5,
                                          autoPlay: true,
                                          viewportFraction: 1,
                                          autoPlayInterval: const Duration(seconds: 15),
                                        )),
                                  );
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Menu not available.",
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white)),
                                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8)));
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  );
                },
              );
            },
          ),
        ]
      )
    );
  }
}
