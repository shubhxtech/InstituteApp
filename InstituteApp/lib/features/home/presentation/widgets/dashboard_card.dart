import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/glass_container.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final dynamic icon;
  final void Function() onTap;
  final int maxLines;

  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.maxLines = 2,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            // LayoutBuilder lets us compute a responsive icon radius
            // based on the actual cell height supplied by the GridView.
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Reserve space: vertical padding (8*2) + gap (8) + text (~32)
                final double reservedPx = 8 + 8 + 8 + 32;
                final double availableForIcon =
                    constraints.maxHeight - reservedPx;
                // Clamp radius between 24 and 32 logical pixels
                final double radius =
                    (availableForIcon / 2).clamp(22.0, 32.0);

                return GlassContainer(
                  borderRadius: BorderRadius.circular(24),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Use max so the GridView cell constrains us, not content
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Hero(
                        tag: 'icon-${widget.title}',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: -5,
                              )
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor:
                                widget.icon.runtimeType == IconData
                                    ? Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1)
                                    : Colors.white,
                            radius: radius,
                            child: widget.icon.runtimeType == IconData
                                ? Icon(
                                    widget.icon,
                                    // Icon scales proportionally with the avatar
                                    size: radius * 0.85,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  )
                                : ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(radius),
                                    child: CachedNetworkImage(
                                      imageUrl: widget.icon,
                                      fit: BoxFit.cover,
                                      width: radius * 2,
                                      height: radius * 2,
                                      progressIndicatorBuilder:
                                          (context, url, progress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                          value: progress.progress,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                      errorWidget:
                                          (context, object, stacktrace) {
                                        return Icon(
                                            Icons.error_outline_rounded,
                                            size: radius * 0.85,
                                            color: Theme.of(context)
                                                .primaryColor);
                                      },
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          // Always allow 2 lines — prevents overflow on
                          // long labels like "Lost/Found"
                          maxLines: widget.maxLines,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                                height: 1.2,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
