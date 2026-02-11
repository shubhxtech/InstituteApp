import 'dart:developer';
import 'package:vertex/features/home/data/models/job_model.dart';
import 'package:vertex/utils/api_client.dart';

class JobPortalDB {
  final ApiClient _apiClient = ApiClient();

  JobPortalDB();

  static Future<void> connect(String connectionURL) async {
    log("JobPortalDB: connect called (No-op)");
  }

  // Get All Jobs
  Future<List<Job>> getJobs() async {
    try {
      final response = await _apiClient.get('/jobs');
      if (response is List) {
        return response.map((item) => Job.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      log("Error fetching jobs: ${e.toString()}");
      return [];
    }
  }

  Future<void> close() async {}
}
