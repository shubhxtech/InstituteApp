import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/presentation/bloc/post_bloc/post_bloc.dart';
import 'package:vertex/features/home/presentation/widgets/feed_item_card.dart';
import 'package:vertex/utils/env_utils.dart';

class FeedPage extends StatefulWidget {
  final bool isGuest;
  final UserEntity? user;
  const FeedPage({super.key, required this.isGuest, required this.user});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  bool _isAdminUser = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
    // Fetch posts if not already loaded (Bloc usually maintains state, but this ensures fresh data if needed)
    // You might want to remove this if you want to persist the list across tab switches
    // But since the original code had it, I'll keep it but check if state is already loaded? 
    // Actually, forcing refresh on init is fine for now, or we can check state.
    final currentState = BlocProvider.of<PostBloc>(context).state;
    if (currentState is! PostItemsLoaded) {
       BlocProvider.of<PostBloc>(context).add(const GetPostItemsEvent());
    }
  }

  Future<void> _checkAdminStatus() async {
    if (widget.user != null) {
      final adminStatus = await isAdmin(widget.user!.email);
      if (mounted) {
        setState(() {
          _isAdminUser = adminStatus;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    // Using AutomaticKeepAliveClientMixin concept here would require a mixin, 
    // but PageStorageKey helps with scroll position.
    
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostItemsLoading ||
                state is PostInitial ||
                state is PostItemDeleting) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostItemsLoaded) {
              // Filtering happens here, but sorting is in Bloc now.
              List<PostItemEntity> feedItems =
                  state.items.where((post) => post.type == "Feed").toList();
              
              if (feedItems.isEmpty) {
                return Center(
                    child: Text('No feeds available.',
                        style: Theme.of(context).textTheme.bodySmall));
              }
              
              return ListView.separated(
                physics: const ClampingScrollPhysics(),
                primary: true,
                key: const PageStorageKey('feed_list'),
                itemCount: feedItems.length,
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.09),
                itemBuilder: (BuildContext context, int index) {
                  return FeedItemCard(
                    post: feedItems[index],
                    user: widget.user,
                    isGuest: widget.isGuest,
                    isAdminUser: _isAdminUser,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              );
            } else if (state is PostItemsLoadingError) {
              return const Center(
                  child: Text(
                      'Failed to load feed items.\n Check your internet connection.',
                      style: TextStyle(color: Colors.red)));
            } else if (state is PostItemAddedOrEdited ||
                state is PostItemsAddingOrEditingError ||
                state is PostItemDeletedSuccessfully ||
                state is PostItemDeleteError) {
              BlocProvider.of<PostBloc>(context).add(const GetPostItemsEvent());
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        if (!widget.isGuest && widget.user != null && _isAdminUser)
            Positioned(
              right: 5,
              bottom: 5,
              child: GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                      UhlLinkRoutesNames.postAddOrEditItemPage,
                      extra: {
                        "user": widget.user,
                        "postEditing": false,
                         // "postDetails": null is implicit/optional
                      });
                },
                child: CircleAvatar(
                  radius: aspectRatio * 60,
                  backgroundColor:
                      Theme.of(context).primaryColor.withAlpha(100),
                  child: Icon(Icons.add_rounded,
                      size: aspectRatio * 90,
                      color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ),
      ],
    );
  }
}
