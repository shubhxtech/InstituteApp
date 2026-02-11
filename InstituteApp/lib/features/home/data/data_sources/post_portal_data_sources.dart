import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:vertex/features/home/data/models/post_model.dart';
import 'package:vertex/utils/api_client.dart';
import 'package:vertex/utils/cloudinary_services.dart';

class PostDB {
  final ApiClient _apiClient = ApiClient();

  PostDB();

  static Future<void> connect(String connectionURL) async {
    log("PostDB: connect called (No-op)");
  }

  // Get All Posts
  Future<List<PostItem>> getPostItems() async {
    try {
      final response = await _apiClient.get('/posts');
      if (response is List) {
        return response.map((item) => PostItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching posts: ${e.toString()}");
      return [];
    }
  }

  // Add/Edit Post
  Future<PostItem?> addOrEditPostitem(
    String? id,
    String title,
    String description,
    FilePickerResult images,
    String link,
    String host,
    String type,
    String emailId,
    DateTime createdAt,
    DateTime updatedAt,
  ) async {
    List<String> imagesList = await uploadImagesToBNS(images);

    final Map<String, dynamic> data = {
        'title': title,
        'description': description,
        'images': imagesList,
        'link': link,
        'host': host,
        'type': type,
        'emailId': emailId,
        // timestamps handled by backend
    };

    try {
      if (id != null) {
        // Update
        final response = await _apiClient.put('/posts/$id', data);
        return PostItem.fromJson(response);
      } else {
        // Create
        final response = await _apiClient.post('/posts', data);
        return PostItem.fromJson(response);
      }
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Delete Post
  Future<bool> deletePostItem(String id) async {
    try {
      await _apiClient.delete('/posts/$id');
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<void> close() async {}
}
