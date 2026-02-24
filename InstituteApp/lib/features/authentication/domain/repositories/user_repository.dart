import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity?> signUpUser(String name, String email, String password);
  Future<bool> sendOTP(String name, String email, String password, int otp);
  Future<UserEntity?> signInUser(String email, String password);
  Future<bool?> updatePassword(String email, String password);
  Future<UserEntity?> getUserByEmail(String email);
  Future<UserEntity?> updateProfile(String name, String email, String password);
}