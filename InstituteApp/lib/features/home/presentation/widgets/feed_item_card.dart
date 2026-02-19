import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/presentation/bloc/post_bloc/post_bloc.dart';
import 'package:vertex/features/home/presentation/widgets/post_detail_page.dart';
import 'package:vertex/widgets/glass_container.dart';

class FeedItemCard extends StatelessWidget {
  final PostItemEntity post;
  final UserEntity? user;
  final bool isGuest;
  final bool isAdminUser;

  const FeedItemCard({
    super.key,
    required this.post,
    required this.user,
    required this.isGuest,
    required this.isAdminUser,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double aspectRatio = screenWidth / screenHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: RepaintBoundary(
        child: GlassContainer(
          // Reduced blur for performance
          blur: 10, 
          opacity: 0.1,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (post.images.isNotEmpty)
                    CarouselSlider(
                      items: post.images
                          .map((image) => ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15)),
                                child: Hero(
                                  tag: image,
                                  child: CachedNetworkImage(
                                      imageUrl: image,
                                      height: screenHeight * 0.25,
                                      width: screenWidth - 20,
                                      memCacheHeight: (screenHeight * 0.25 * MediaQuery.of(context).devicePixelRatio).round(),
                                      placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget: (context, object, stacktrace) {
                                        return Icon(Icons.error_outline_rounded,
                                            size: 40,
                                            color: Theme.of(context).primaryColor);
                                      },
                                      fit: BoxFit.cover),
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                          height: screenHeight * 0.3,
                          autoPlay: false, // Disabled autoPlay for performance in list
                          aspectRatio: 16 / 9,
                          viewportFraction: 1,
                          enlargeCenterPage: true),
                    ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height * 0.015,
                        vertical: MediaQuery.of(context).size.height * 0.015),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.title,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        SizedBox(height: screenHeight * 0.005),
                        Text(post.description.trim(),
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(180))),
                        SizedBox(height: screenHeight * 0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(post.host,
                                textAlign: TextAlign.start,
                                softWrap: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(fontSize: 17)),
                            Text(
                                DateFormat.yMMMMd()
                                    .format(post.createdAt),
                                textAlign: TextAlign.end,
                                softWrap: true,
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PostDetailPage(
                                        type: post.type,
                                        images: post.images,
                                        host: post.host,
                                        description: post.description,
                                        link: post.link,
                                        title: post.title,
                                        createdAt: post.createdAt)));
                          },
                          child: Text("View more...",
                              textAlign: TextAlign.start,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: PopupMenuButton(
                  icon: CircleAvatar(
                    radius: aspectRatio * 40,
                    backgroundColor:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(100),
                    child: Icon(Icons.more_vert_rounded,
                        size: aspectRatio * 60,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                      width: 1,
                    ),
                  ),
                  onSelected: (value) {
                    if (isGuest) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'You need to login to edit/delete feeds.',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                      );
                      return;
                    }
                    if (!isAdminUser) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "You don't have access to edit/delete feeds.",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                      );
                      return;
                    }
                    if (value == 1) {
                      GoRouter.of(context).pushNamed(
                          UhlLinkRoutesNames.postAddOrEditItemPage,
                          extra: {
                            "user": user,
                            "postEditing": true,
                            "postDetails": post
                          });
                    } else if (value == 2) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Feed',
                                style: Theme.of(context).textTheme.bodyMedium),
                            content: Text(
                                'Are you sure you want to delete this feed item?',
                                style: Theme.of(context).textTheme.labelSmall),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel',
                                    style: Theme.of(context).textTheme.labelSmall),
                              ),
                              TextButton(
                                onPressed: () {
                                  BlocProvider.of<PostBloc>(context).add(
                                      DeletePostItemEvent(id: post.id));
                                  Navigator.of(context).pop();
                                },
                                child: Text('Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color:
                                              Theme.of(context).colorScheme.onError,
                                          fontWeight: FontWeight.w700,
                                        )),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 1,
                      child: Text('Edit',
                          style: Theme.of(context).textTheme.labelSmall),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: Text('Delete',
                          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                color: Theme.of(context).colorScheme.onError,
                              )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
