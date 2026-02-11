// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PorsPage extends StatefulWidget {
  const PorsPage({super.key});

  @override
  State<PorsPage> createState() => _PorsPageState();
}

class _PorsPageState extends State<PorsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title:
        Text("Achievements/PORs", style: Theme.of(context).textTheme.bodyMedium),
        centerTitle: true,
      ),
    );
  }
}
