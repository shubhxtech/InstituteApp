class MessMenu {
  final String day;
  final Map<String, List<String>> meals;

  MessMenu({
    required this.day,
    required this.meals,
  });

  factory MessMenu.fromJson(Map<String, dynamic> json) {
    return MessMenu(
      day: json['day'] ?? '',
      meals: {
        'Breakfast': List<String>.from(json['meals']['breakfast'] ?? []),
        'Lunch': List<String>.from(json['meals']['lunch'] ?? []),
        'Snacks': List<String>.from(json['meals']['snacks'] ?? []),
        'Dinner': List<String>.from(json['meals']['dinner'] ?? []),
      },
    );
  }
}
