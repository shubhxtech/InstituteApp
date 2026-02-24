import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vertex/config/routes/routes_consts.dart';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/features/home/domain/entities/post_entity.dart';
import 'package:vertex/features/home/presentation/bloc/post_bloc/post_bloc.dart';
import 'package:vertex/features/home/presentation/widgets/post_detail_page.dart';

class FeedItemCard extends StatefulWidget {
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
  State<FeedItemCard> createState() => _FeedItemCardState();
}

class _FeedItemCardState extends State<FeedItemCard> {
  int _currentImageIndex = 0;

  // Category color mapping
  Color _categoryColor(BuildContext context) {
    switch (widget.post.type.toLowerCase()) {
      case 'announcement':
        return Colors.orange.shade700;
      case 'event':
        return Colors.purple.shade600;
      case 'achievement':
        return Colors.green.shade600;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  String _categoryLabel() {
    switch (widget.post.type.toLowerCase()) {
      case 'announcement':
        return 'Announcement';
      case 'event':
        return 'Event';
      case 'achievement':
        return 'Achievement';
      default:
        return 'Feed';
    }
  }

  void _openDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          type: widget.post.type,
          images: widget.post.images,
          host: widget.post.host,
          description: widget.post.description,
          link: widget.post.link,
          title: widget.post.title,
          createdAt: widget.post.createdAt,
        ),
      ),
    );
  }

  Future<void> _launchLink() async {
    String link = widget.post.link.trim();
    if (link.isEmpty) return;
    if (!link.startsWith('http://') && !link.startsWith('https://')) {
      link = 'https://$link';
    }
    final uri = Uri.tryParse(link);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Could not launch $link');
      }
    }
  }

  void _showAdminMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit Post'),
              onTap: () {
                Navigator.pop(ctx);
                GoRouter.of(context).pushNamed(
                  UhlLinkRoutesNames.postAddOrEditItemPage,
                  extra: {
                    'user': widget.user,
                    'postEditing': true,
                    'postDetails': widget.post,
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red.shade400),
              title: Text('Delete Post',
                  style: TextStyle(color: Colors.red.shade400)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this feed post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<PostBloc>(context)
                  .add(DeletePostItemEvent(id: widget.post.id));
              Navigator.pop(ctx);
            },
            child:
                Text('Delete', style: TextStyle(color: Colors.red.shade500)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = _categoryColor(context);
    final hasImages = widget.post.images.isNotEmpty;
    final hasLink = widget.post.link.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: colorScheme.onSurface.withAlpha(25),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _openDetail,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image Carousel ──────────────────────────────────────
              if (hasImages)
                Stack(
                  children: [
                    SizedBox(
                      height: 220,
                      width: double.infinity,
                      child: PageView.builder(
                        itemCount: widget.post.images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImageIndex = i),
                        itemBuilder: (context, i) => CachedNetworkImage(
                          imageUrl: widget.post.images[i],
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) => Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: const Center(
                                child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (ctx, url, err) => Container(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(Icons.broken_image_outlined,
                                size: 40,
                                color: colorScheme.onSurface.withAlpha(80)),
                          ),
                        ),
                      ),
                    ),
                    // Category chip on top of image
                    Positioned(
                      top: 12,
                      left: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _categoryLabel(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                    // Admin menu button
                    if (widget.isAdminUser)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _showAdminMenu,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withAlpha(100),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.more_vert,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    // Dot indicators
                    if (widget.post.images.length > 1)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.post.images.length,
                            (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: i == _currentImageIndex ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: i == _currentImageIndex
                                    ? Colors.white
                                    : Colors.white.withAlpha(128),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

              // ── Content ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip (when no image)
                    if (!hasImages)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: categoryColor.withAlpha(30),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: categoryColor.withAlpha(80), width: 1),
                            ),
                            child: Text(
                              _categoryLabel(),
                              style: TextStyle(
                                color: categoryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (widget.isAdminUser)
                            GestureDetector(
                              onTap: _showAdminMenu,
                              child: Icon(Icons.more_horiz,
                                  color: colorScheme.onSurface.withAlpha(120)),
                            ),
                        ],
                      ),

                    if (!hasImages) const SizedBox(height: 10),

                    Text(
                      widget.post.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.post.description.trim(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(160),
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 12),

                    // ── Footer ──────────────────────────────────────
                    Row(
                      children: [
                        // Author avatar
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: categoryColor.withAlpha(40),
                          child: Text(
                            widget.post.host.isNotEmpty
                                ? widget.post.host[0].toUpperCase()
                                : 'V',
                            style: TextStyle(
                              color: categoryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post.host,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                DateFormat('d MMM yyyy')
                                    .format(widget.post.createdAt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(120),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Link button
                        if (hasLink)
                          InkWell(
                            onTap: _launchLink,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: theme.primaryColor.withAlpha(60)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.open_in_new_rounded,
                                      size: 13, color: theme.primaryColor),
                                  const SizedBox(width: 4),
                                  Text('Link',
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        if (!hasLink) ...[
                          GestureDetector(
                            onTap: _openDetail,
                            child: Text(
                              'Read more',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
