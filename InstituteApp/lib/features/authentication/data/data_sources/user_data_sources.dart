import 'dart:developer';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/utils/api_client.dart';
import '../models/user_model.dart';
// import 'package:vertex/utils/password_functions.dart'; // No longer needed for hashing

class UhlUsersDB {
  final ApiClient _apiClient = ApiClient();

  UhlUsersDB();

  // No-op for compatibility
  static Future<void> connect(String connectionURL) async {
    log("UhlUsersDB: connect called (No-op for API)");
  }

  // Get All Data - Deprecated/Not supported in API for client
  Future<List<Object>?> getData() async {
    return [];
  }

  // Get All Users Method - Deprecated
  Future<List<User>?> getUsers() async {
    return [];
  }

  // create
  Future<User?> createUser(
      String name, String email, String password, String? image) async {
    try {
      final response = await _apiClient.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password, // Send raw password (over HTTPS in prod)
        'image': image ?? ""
      });
      
      return User.fromJson(response);
    } catch (e) {
      log("Error creating user: ${e.toString()}");
      return null;
    }
  }

  // Update Password
  Future<bool?> updatePassword(String email, String password) async {
    try {
      await _apiClient.put('/auth/password', {
        'email': email,
        'password': password
      });
      return true;
    } catch (e) {
      log("Error updating password: ${e.toString()}");
      return false;
    }
  }

  // Update Profile
  Future<UserEntity?> updateProfile(
      String name, String email, String password, String? image) async {
    try {
       // Note: Token should be handled by ApiClient from storage
       // We pass fields to update
       final response = await _apiClient.put('/auth/profile', {
        'name': name,
        'email': email,
        if (password.isNotEmpty) 'password': password,
        'image': image ?? ""
      });
      return UserEntity.fromJson(response);
    } catch (e) {
      log("Error updating profile: ${e.toString()}");
      return null;
    }
  }

  // Update Image
  Future<bool?> updateImage(String id, String image) async {
    try {
      await _apiClient.put('/auth/profile', {
        'image': image
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  // Get By Email And Password (Login)
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', {
        'email': email,
        'password': password
      });
      return User.fromJson(response);
    } catch (e) {
      log("Login failed: ${e.toString()}");
      return null;
    }
  }

  // Get User By Email (Check existence)
  Future<List<User>> getUserByEmail(String email) async {
    try {
      final response = await _apiClient.post('/auth/check-email', {
        'email': email
      });
      if (response['exists'] == true) {
        // Return a dummy user to satisfy List<User> return type 
        // expected by repository checking `isNotEmpty`
        return [
           User(id: 'exists', image: '', name: '', email: email, password: '')
        ];
      } else {
        return [];
      }
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  // Send OTP
  Future<int?> sendOtp(String name, String email, int otp) async {
    try {
      final response = await _apiClient.post('/auth/send-otp', {
        'name': name,
        'email': email,
        'otp': otp
      });
      return response['otp'];
    } catch (e) {
      log("Error sending OTP: ${e.toString()}");
      return null;
    }
  }

  // Get User By ID - Deprecated/Not implemented
  Future<List<User>> getUserById(String id) async {
    return []; 
  }

  // Close Connection
  Future<void> close() async {
    log('Connection (Fake) closed');
  }
}
