import 'package:flutter/foundation.dart';
import 'package:vertex/features/home/data/data_sources/dynamic_content_data_source.dart';
import 'package:vertex/features/home/data/models/mess_menu_model.dart';
import 'package:vertex/features/home/data/models/cafeteria_model.dart';
import 'package:vertex/features/home/data/models/carousel_image_model.dart';
import 'package:vertex/features/home/data/models/calendar_event_model.dart';
import 'package:vertex/utils/constants.dart';

class DynamicContentProvider with ChangeNotifier {
  final DynamicContentDataSource _dataSource = DynamicContentDataSource();

  Map<String, MessMenu> _messMenu = {};
  List<Cafeteria> _cafeterias = [];
  List<CarouselImage> _carouselImages = [];
  List<CalendarEvent> _calendarEvents = [];
  bool _isLoading = false;

  Map<String, MessMenu> get messMenu => _messMenu;
  List<Cafeteria> get cafeterias => _cafeterias;
  List<CarouselImage> get carouselImages => _carouselImages;
  List<CalendarEvent> get calendarEvents => _calendarEvents;
  bool get isLoading => _isLoading;

  Future<void> fetchAllContent() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _dataSource.getMessMenu(),
        _dataSource.getCafeterias(),
        _dataSource.getCarouselImages(),
        _dataSource.getCalendarEvents(),
      ]);

      _messMenu = results[0] as Map<String, MessMenu>;
      _cafeterias = results[1] as List<Cafeteria>;
      _carouselImages = results[2] as List<CarouselImage>;
      _calendarEvents = results[3] as List<CalendarEvent>;
      
    } catch (e) {
      print("Error fetching dynamic content: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper to get raw map for backward compatibility with existing UI
  Map<String, Map<String, List<String>>> get messMenuMap {
    if (_messMenu.isEmpty) return Constants.messMenu; // Fallback to hardcoded if empty
    
    Map<String, Map<String, List<String>>> map = {};
    _messMenu.forEach((day, menu) {
      map[day] = menu.meals;
    });
    return map;
  }
}
