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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: GlassContainer(
          opacity: 0.1,
          child: SizedBox(
            height: MediaQuery.of(context).size.aspectRatio * 132,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                Icon(widget.icon,
                    size: 25, color: Theme.of(context).colorScheme.onSurface),
                SizedBox(width: MediaQuery.of(context).size.width * 0.08),
                Text(widget.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
