import 'dart:developer';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../data_sources/user_data_sources.dart';

class UserRepositoryImpl implements UserRepository {
  final UhlUsersDB authDatabase;
  UserRepositoryImpl(this.authDatabase);

  @override
  Future<UserEntity?> signInUser(String email, String password) async {
    final user = await authDatabase.getUserByEmailAndPassword(email, password);
    if (user != null) {
      return UserEntity(
          name: user.name,
          email: user.email,
          password: user.password,
          image: user.image,
          token: user.token);
    } else {
      return null;
    }
  }

  @override
  Future<bool> sendOTP(String name, String email, String password,
      String? image, int otp) async {
    try {
       // Call data source (which calls backend)
       // The backend returns the OTP if successful.
       final returnedOtp = await authDatabase.sendOtp(name, email, otp);
       
       return returnedOtp != null;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<UserEntity?> signUpUser(
      String name, String email, String password, String? image) async {
    final user = await authDatabase.createUser(name, email, password, image);
    if (user != null) {
      return UserEntity(
          name: user.name,
          email: user.email,
          password: user.password,
          image: user.image,
          token: user.token);
    } else {
      return null;
    }
  }

  @override
  Future<bool?> updatePassword(String email, String password) async {
    return await authDatabase.updatePassword(email, password);
  }

  @override
  Future<UserEntity?> getUserByEmail(String email) async {
    final user = await authDatabase.getUserByEmail(email);
    if (user.isNotEmpty) {
      return UserEntity(
          name: user.first.name,
          email: user.first.email,
          password: user.first.password,
          image: user.first.image);
    } else {
      return null;
    }
  }

  @override
  Future<UserEntity?> updateProfile(
      String name, String email, String password, String? image) async {
    UserEntity? user =
        await authDatabase.updateProfile(name, email, password, image);
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }
}
