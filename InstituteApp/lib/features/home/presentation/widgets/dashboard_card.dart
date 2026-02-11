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
    this.maxLines = 1,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fanAnimation;

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
    _fanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
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
            child: GlassContainer(
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'icon-${widget.title}',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: -5,
                          )
                        ]
                      ),
                      child: CircleAvatar(
                        backgroundColor: widget.icon.runtimeType == IconData 
                            ? Theme.of(context).primaryColor.withOpacity(0.1) 
                            : Colors.white,
                        radius: 32,
                        child: widget.icon.runtimeType == IconData
                            ? Icon(widget.icon,
                                size: 28,
                                color: Theme.of(context).colorScheme.primary)
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: CachedNetworkImage(
                                  imageUrl: widget.icon,
                                  fit: BoxFit.cover,
                                  width: 64,
                                  height: 64,
                                  progressIndicatorBuilder: (context, url, progress) =>
                                      Center(
                                    child: CircularProgressIndicator(
                                      value: progress.progress,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                  errorWidget: (context, object, stacktrace) {
                                    return Icon(Icons.error_outline_rounded,
                                        size: 28, color: Theme.of(context).primaryColor);
                                  },
                                ),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    maxLines: widget.maxLines,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                          height: 1.2,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStackLayer(BuildContext context, {required double offset, required double scale, required double rotation, required double opacity}) {
    // Using a fixed size that matches roughly the card size, or let it be sized by the stack if possible.
    // However, in a GridView, constraints are passed down.
    // We can use a Container with same decoration but no child.
    return Positioned(
      top: -offset, 
      left: 0, 
      right: 0,
      bottom: offset, // Pull up visually
      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(opacity * 0.5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
          ),
        ),
      ),
    );
  }
}
