import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class GetUserByEmail {
  final UserRepository repository;

  GetUserByEmail(this.repository);

  Future<UserEntity?> execute(String email) {
    return repository.getUserByEmail(email);
  }
}
