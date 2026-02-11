import 'dart:developer';
import 'package:vertex/features/home/data/models/notification_model.dart';
import 'package:vertex/utils/api_client.dart';
import 'package:vertex/utils/cloudinary_services.dart';

class NotificationsDB {
  final ApiClient _apiClient = ApiClient();

  NotificationsDB();

  static Future<void> connect(String connectionURL) async {
    log("NotificationsDB: connect called (No-op)");
  }

  // Get All Notifications
  Future<List<Notification>> getNotifications() async {
    try {
      final response = await _apiClient.get('/notifications');
      if (response is List) {
        return response.map((item) => Notification.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching notifications: ${e.toString()}");
      return [];
    }
  }

  // Add Notification
  Future<Notification?> addNotifications(
    String title,
    String by,
    String description,
    String? image,
  ) async {
    if (image != null && !image.startsWith('http')) {
       // Assume it's a path needing upload, but helper expects File not path usually?
       // The original code passed 'image' as String to uploadImageToNotifications
       // which took String path.
       image = await uploadImageToNotifications(image);
    }

    try {
      final response = await _apiClient.post('/notifications', {
        'title': title,
        'by': by,
        'description': description,
        'image': image ?? ""
      });
      return Notification.fromJson(response);
    } catch (e) {
      log("Error creating notification: ${e.toString()}");
      return null;
    }
  }

  Future<void> close() async {}
}
