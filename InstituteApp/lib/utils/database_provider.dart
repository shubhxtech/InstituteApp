import 'dart:developer';
import 'package:flutter/material.dart';

class DatabaseProvider with ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connectToDB() async {
    // No direct DB connection needed — the app uses the REST API.
    _isConnected = true;
    notifyListeners();
    log('DatabaseProvider: Using REST API (no direct DB connection)');
  }
}
