import 'dart:developer';
import 'package:vertex/features/home/data/models/buy_sell_item_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:vertex/utils/api_client.dart';
import 'package:vertex/utils/cloudinary_services.dart';

class BuySellDB {
  final ApiClient _apiClient = ApiClient();

  BuySellDB();

  // No-op for compatibility
  static Future<void> connect(String connectionURL) async {
     log("BuySellDB: connect called (No-op regarding MongoDB)");
  }

  // Get All Buy & Sell Items
  Future<List<BuySellItem>> getBuySellItems() async {
    try {
      final response = await _apiClient.get('/buy-sell');
      if (response is List) {
        return response.map((item) => BuySellItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching buy & sell items: ${e.toString()}");
      return [];
    }
  }

  Future<BuySellItem?> addOrEditItem(
    String? id,
    String name,
    String productDescription,
    FilePickerResult productImage,
    String soldBy,
    String maxPrice,
    String minPrice,
    DateTime createdAt,
    DateTime updatedAt,
    String phoneNo,
  ) async {
    List<String> imagesList = await uploadImagesToBNS(productImage);
    
    final Map<String, dynamic> data = {
        'name': name,
        'productDescription': productDescription,
        'productImage': imagesList,
        'soldBy': soldBy,
        'maxPrice': maxPrice,
        'minPrice': minPrice,
        'phoneNo': phoneNo,
        // Backend manages timestamps
    };

    try {
        if (id != null) {
            // Update
            final response = await _apiClient.put('/buy-sell/$id', data);
            return BuySellItem.fromJson(response);
        } else {
            // Create
            final response = await _apiClient.post('/buy-sell', data);
            return BuySellItem.fromJson(response);
        }
    } catch (e) {
        log("Error posting/updating item: ${e.toString()}");
        return null;
    }
  }

    // Delete BuySell Item
  Future<bool> deleteBuySellItem(String id) async {
    try {
      await _apiClient.delete('/buy-sell/$id');
      return true;
    } catch (e) {
      log("Error deleting item: ${e.toString()}");
      return false;
    }
  }

  // Close Database Connection
  Future<void> close() async {
    // No-op
  }
}
