import 'package:bcrypt/bcrypt.dart';

String hashPassword(String password) {
  String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
  return hashedPassword;
}

bool validatePassword(String enteredPassword, String hashedPassword) {
  return BCrypt.checkpw(enteredPassword, hashedPassword);
}
