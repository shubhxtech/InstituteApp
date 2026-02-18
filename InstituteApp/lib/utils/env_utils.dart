import 'dart:developer';
import 'package:vertex/utils/functions.dart';

/// Returns the list of admin/POR email addresses.
/// These are the official club/secretary emails that have elevated privileges.
Future<List<String>> getAdminEmails() async {
  // Admin emails are managed server-side via the POR_EMAILS env variable.
  // The Flutter app checks admin status via the user's role returned by the API.
  // This list is kept as a client-side fallback for UI-level checks only.
  return const [
    'b23011@students.iitmandi.ac.in',
    'pc@iitmandi.ac.in',
    'technical_secretary@students.iitmandi.ac.in',
    'research_secretary@students.iitmandi.ac.in',
    'pgacademic_secretary@students.iitmandi.ac.in',
    'ugacademic_secretary@students.iitmandi.ac.in',
    'robotronics@students.iitmandi.ac.in',
    'yantrik_club@students.iitmandi.ac.in',
    'pc@students.iitmandi.ac.in',
    'sae@iitmandi.ac.in',
    'stac@students.iitmandi.ac.in',
    'edc@students.iitmandi.ac.in',
    'nirmaan_club@students.iitmandi.ac.in',
    'cultural_secretary@students.iitmandi.ac.in',
    'academic_secretary@students.iitmandi.ac.in',
    'media@students.iitmandi.ac.in',
    'literary_secretary@students.iitmandi.ac.in',
    'danceclub@students.iitmandi.ac.in',
    'designauts@students.iitmandi.ac.in',
    'dramaclub@students.iitmandi.ac.in',
    'ebsb@students.iitmandi.ac.in',
    'spicmacay@students.iitmandi.ac.in',
    'pmc@students.iitmandi.ac.in',
    'musicclub@students.iitmandi.ac.in',
    'artgeeks@students.iitmandi.ac.in',
    'writing_club@students.iitmandi.ac.in',
    'debating_club@students.iitmandi.ac.in',
    'quizzing_club@students.iitmandi.ac.in',
  ];
}

Future<bool> isAdmin(String email) async {
  final adminEmails = await getAdminEmails();
  return adminEmails.contains(email);
}
