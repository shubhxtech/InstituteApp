import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/data/models/lost_found_item_model.dart';
import 'package:vertex/utils/api_client.dart';
import 'package:vertex/utils/cloudinary_services.dart';

class LostFoundDB {
  final ApiClient _apiClient = ApiClient();

  LostFoundDB();

  static Future<void> connect(String connectionURL) async {
    log("LostFoundDB: connect called (No-op)");
  }

  // Get All Items
  Future<List<LostFoundItem>> getLostFoundItems() async {
    try {
      final response = await _apiClient.get('/lost-found');
      if (response is List) {
        return response.map((item) => LostFoundItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching items: ${e.toString()}");
      return [];
    }
  }

  Future<LostFoundItem?> addOrEditLostFoundItem(
    String? id,
    String from,
    String lostOrFound,
    String name,
    String description,
    FilePickerResult images,
    DateTime createdAt,
    DateTime updatedAt,
    String phoneNo,
  ) async {
    List<String> imagesList = await uploadImagesToBNS(images);

    final Map<String, dynamic> data = {
        'lostOrFound': lostOrFound,
        'name': name,
        'description': description,
        'images': imagesList,
        'from': from,
        'phoneNo': phoneNo
    };

    try {
      if (id != null) {
        // Update
        final response = await _apiClient.put('/lost-found/$id', data);
        return LostFoundItem.fromJson(response);
      } else {
        // Create
        final response = await _apiClient.post('/lost-found', data);
        return LostFoundItem.fromJson(response);
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Delete
  Future<bool> deleteLostFoundItem(String id) async {
    try {
      await _apiClient.delete('/lost-found/$id');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> close() async {}
}
