import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Hashes [password] with SHA-256 before sending to the server.
/// This ensures the raw password never leaves the device — the server then
/// bcrypt-hashes the SHA-256 digest for storage, so both layers are applied.
/// SHA-256 is used (not bcrypt) because it is deterministic: the same password
/// always produces the same digest, which is required for login comparisons.
String sha256HashPassword(String password) {
  final bytes = utf8.encode(password);
  final digest = sha256.convert(bytes);
  return digest.toString(); // 64-char lowercase hex string
}
