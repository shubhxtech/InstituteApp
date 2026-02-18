// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'glass_button.dart';

class ScreenWidthButton extends StatefulWidget {
  final String text;
  final Function() buttonFunc;
  bool isLoading;
  ScreenWidthButton(
      {super.key,
      required this.text,
      required this.buttonFunc,
      this.isLoading = false});

  @override
  State<ScreenWidthButton> createState() => _ScreenWidthButtonState();
}

class _ScreenWidthButtonState extends State<ScreenWidthButton> {
  @override
  Widget build(BuildContext context) {
    return GlassButton(
      text: widget.text,
      onPressed: widget.buttonFunc,
      width: MediaQuery.of(context).size.width - 40,
      isLoading: widget.isLoading,
      height: 46,
    );
  }
}
