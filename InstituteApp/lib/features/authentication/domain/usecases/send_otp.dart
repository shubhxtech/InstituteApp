import '../repositories/user_repository.dart';

class SendOTP {
  final UserRepository repository;

  SendOTP(this.repository);

  Future<bool> execute(String name, String email, String password, String? image, int otp) async {
    return await repository.sendOTP(name, email, password, image, otp);
  }
}
