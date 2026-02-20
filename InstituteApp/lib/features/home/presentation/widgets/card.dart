import 'package:vertex/widgets/glass_container.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatefulWidget {
  final String text;
  final IconData icon;
  final Function() onTap;
  final bool isTrue;

  const CardWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.onTap,
      this.isTrue = false});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: GlassContainer(
          opacity: 0.1,
          child: SizedBox(
            // Use a fixed height instead of aspectRatio * 132 which
            // collapses to ~59px on tall/narrow phones (aspectRatio ≈ 0.45)
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                Icon(widget.icon,
                    size: 25, color: Theme.of(context).colorScheme.onSurface),
                SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                Expanded(
                  child: Text(
                    widget.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
