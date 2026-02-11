import 'dart:developer';
import 'package:vertex/utils/functions.dart';
import 'package:flutter/material.dart';
import '../features/authentication/data/data_sources/user_data_sources.dart'
    show UhlUsersDB;
import '../features/home/data/data_sources/post_portal_data_sources.dart'
    show PostDB;
import '../features/home/data/data_sources/notification_data_sources.dart'
    show NotificationsDB;
import '../features/home/data/data_sources/buy_sell_data_sources.dart'
    show BuySellDB;
import '../features/home/data/data_sources/job_portal_data_sources.dart'
    show JobPortalDB;
import '../features/home/data/data_sources/lost_found_data_sources.dart';

class DatabaseProvider with ChangeNotifier {
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> connectToDB() async {
    // No MongoDB connections needed - using API
    _isConnected = true;
    notifyListeners();
    log('DatabaseProvider: Using API (no direct DB connection)');
  }
}
