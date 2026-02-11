import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class SignInUser {
  final UserRepository repository;

  SignInUser(this.repository);

  Future<UserEntity?> execute(String email, String password) {
    return repository.signInUser(email, password);
  }
}
