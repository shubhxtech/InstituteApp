import 'dart:convert';
import 'dart:developer';
import 'package:vertex/utils/api_client.dart';
import 'package:vertex/features/home/data/models/mess_menu_model.dart';
import 'package:vertex/features/home/data/models/cafeteria_model.dart';
import 'package:vertex/features/home/data/models/carousel_image_model.dart';
import 'package:vertex/features/home/data/models/calendar_event_model.dart';

class DynamicContentDataSource {
  final ApiClient _apiClient = ApiClient();

  // Get Mess Menu
  Future<Map<String, MessMenu>> getMessMenu() async {
    try {
      final response = await _apiClient.get('/admin/mess-menu');
      if (response is List) {
        final Map<String, MessMenu> menuMap = {};
        for (var item in response) {
          final menu = MessMenu.fromJson(item);
          menuMap[menu.day] = menu;
        }
        return menuMap;
      }
      return {};
    } catch (e) {
      log("Error fetching mess menu: ${e.toString()}");
      return {};
    }
  }

  // Get Cafeterias
  Future<List<Cafeteria>> getCafeterias() async {
    try {
      final response = await _apiClient.get('/admin/cafeteria');
      if (response is List) {
        return response.map((item) => Cafeteria.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      log("Error fetching cafeterias: ${e.toString()}");
      return [];
    }
  }

  // Get Carousel Images
  Future<List<CarouselImage>> getCarouselImages() async {
    try {
      final response = await _apiClient.get('/admin/carousel');
      if (response is List) {
        return response.map((item) => CarouselImage.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      log("Error fetching carousel images: ${e.toString()}");
      return [];
    }
  }

  // Get Calendar Events
  Future<List<CalendarEvent>> getCalendarEvents() async {
    try {
      final response = await _apiClient.get('/admin/events');
      if (response is List) {
        return response.map((item) => CalendarEvent.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      log("Error fetching calendar events: ${e.toString()}");
      return [];
    }
  }
}
