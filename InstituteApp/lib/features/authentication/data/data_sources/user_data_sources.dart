import 'dart:developer';
import 'package:vertex/features/authentication/domain/entities/user_entity.dart';
import 'package:vertex/utils/api_client.dart';
import '../models/user_model.dart';
import 'package:vertex/utils/password_functions.dart';

class UhlUsersDB {
  final ApiClient _apiClient = ApiClient();

  UhlUsersDB();

  static Future<void> connect(String connectionURL) async {
    log("UhlUsersDB: connect called (No-op for API)");
  }

  Future<List<Object>?> getData() async => [];
  Future<List<User>?> getUsers() async => [];

  // Register
  Future<User?> createUser(String name, String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/register', {
        'name': name,
        'email': email,
        'password': sha256HashPassword(password),
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
        'password': sha256HashPassword(password)
      });
      return true;
    } catch (e) {
      log("Error updating password: ${e.toString()}");
      return false;
    }
  }

  // Update Profile (name + optional password, no image)
  Future<UserEntity?> updateProfile(String name, String email, String password) async {
    try {
      final response = await _apiClient.put('/auth/profile', {
        'name': name,
        'email': email,
        if (password.isNotEmpty) 'password': sha256HashPassword(password),
      });
      return UserEntity.fromJson(response);
    } catch (e) {
      log("Error updating profile: ${e.toString()}");
      return null;
    }
  }

  // Login
  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    try {
      final response = await _apiClient.post('/auth/login', {
        'email': email,
        'password': sha256HashPassword(password)
      });
      return User.fromJson(response);
    } catch (e) {
      log("Login failed: ${e.toString()}");
      return null;
    }
  }

  // Check email existence
  Future<List<User>> getUserByEmail(String email) async {
    try {
      final response = await _apiClient.post('/auth/check-email', {'email': email});
      if (response['exists'] == true) {
        return [User(id: 'exists', name: '', email: email, password: '')];
      }
      return [];
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

  Future<List<User>> getUserById(String id) async => [];
  Future<void> close() async => log('Connection (Fake) closed');
}
