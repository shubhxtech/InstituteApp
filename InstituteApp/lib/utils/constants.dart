import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class Constants {
  // Light Theme
  static Color primaryLight = const Color(0xFF3283D5);
  static Color scaffoldBackgroundColorLight = const Color(0xFFFFFFFF);
  static Color textColorActiveLight = const Color(0xFF212121);
  static Color textColorInactiveLight = const Color(0xFF606260);
  static Color cardLight = const Color(0xFFF4F4F4);
  static Color errorLight = const Color(0xFFE55D59);

  // Dark Theme
  static Color primaryDark = const Color(0xFF3283D5);
  static Color scaffoldBackgroundColorDark = const Color(0xFF1A1A1A);
  static Color textColorActiveDark = const Color(0xFFFFFFFF);
  static Color textColorInactiveDark = const Color(0xFF9A9A9A);
  static Color cardDark = const Color(0xFF212121);
  static Color errorDark = const Color(0xFFE55D59);

  static Map<String, Map<String, List<String>>> messMenu = {
    "Monday": {
      "Breakfast": [
        "Aloo onion paratha",
        "Chutney",
        "Curd",
        "Fruits / Eggs",
        "Daliya",
        "Milk(200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong+Lemon)"
      ],
      "Lunch": [
        "Arher Dal",
        "Veg Kofta",
        "Roti",
        "Rice",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Aloo Palak",
        "Dal Fry",
        "Motichur Laddu",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Tuesday": {
      "Breakfast": [
        "Puri",
        "Chana Masala",
        "Halwa",
        "Cornflakes",
        "Milk(200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Moong Dal",
        "Cabbage-Matar",
        "Rice",
        "Roti",
        "Bundi Raita",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Mix Veg (gajar+paneer or Mushroom+bean +gobi+matar)",
        "Dal Tadka",
        "Besan Burfi",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Wednesday": {
      "Breakfast": [
        "Mix Paratha",
        "Dhaniya Chutney",
        "Curd",
        "Daliya",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Kadhi Pakora",
        "Kaddu Khatta",
        "Masala Papad / Fryums",
        "Roti",
        "Jeera Rice",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Kadahi Paneer / ChickenCurry",
        "Red Massor Dal",
        "Fruit Custard",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Thursday": {
      "Breakfast": [
        "Poha",
        "Green Chutney",
        "Fruits / 2 Omlette",
        "Daliya",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "White Chole",
        "Aloo Began Bhartha",
        "Poori",
        "Bundi Raita",
        "Rice",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Aloo Gobhi",
        "Dal Makhni",
        "Besan Halwa",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Friday": {
      "Breakfast": [
        "Idli",
        "Sambhar & chutney",
        "2 Banana / 2 Eggs",
        "Cornflakes",
        "Milk(200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Rajma",
        "Aloo Tamatar Sabzi",
        "Jeera Rice",
        "Roti",
        "Curd",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Paneer butter masala / Egg Curry",
        "Mix Dal",
        "Gulab Jamun",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Saturday": {
      "Breakfast": [
        "Methi / Palak paratha",
        "Aloo Tamatar Sabji",
        "Fruits / 2 Eggs",
        "Cornflakes",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Paneer Bhurji, Egg Bhurji",
        "Chana Dal",
        "Roti",
        "Rice",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Sarso ka Saag",
        "Dal Fry",
        "Kheer",
        "Roti",
        "Rice",
        "Pickle",
        "Green Salad",
        "Lemon"
      ]
    },
    "Sunday": {
      "Breakfast": [
        "Masala Onion Dosa",
        "Sambar",
        "Coconut Chutney",
        "Daliya",
        "Milk (200 ml)",
        "Bread (4 slices)",
        "Butter",
        "Jam",
        "Bournvita",
        "Coffee Powder / Tea bags",
        "Sprouts(Black Chana+ Moong)"
      ],
      "Lunch": [
        "Bhature",
        "Chole",
        "Green Chutney",
        "Fried Masala Chilli",
        "Khichdi",
        "Butter Milk",
        "Green Salad",
        "Lemon + Pickle"
      ],
      "Dinner": [
        "Paneer Biryani / Chicken Biryani",
        "Aloo soyabean",
        "Raita",
        "Ice Cream",
        "Roti",
        "Green Salad",
        "Lemon + Pickle"
      ]
    }
  };

  static Map<String, dynamic> cafeteria = {
    "cafes": [
      {
        "name": "Monal",
        "time": "9:00 AM - 11:00 PM",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "10:00 AM - 10:00 PM",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/MONAL/IMG_20250325_182730.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/MONAL/IMG_20250325_182739.jpg"
        ],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/MONAL/IMG_20250325_182809.jpg"
        ]
      },
      {
        "name": "Mocha",
        "time": "8:00 AM - 10:00 PM",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "9:00 AM - 9:00 PM",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BAKE_O_MOCHA/WhatsApp%20Image%202025-03-25%20at%2017.38.12_7168dac8.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BAKE_O_MOCHA/WhatsApp%20Image%202025-03-25%20at%2017.38.11_ad611072.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BAKE_O_MOCHA/WhatsApp%20Image%202025-03-25%20at%2017.38.12_726ffc55.jpg"
        ],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BAKE_O_MOCHA/WhatsApp%20Image%202025-03-25%20at%2019.01.48_f4530d7e.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BAKE_O_MOCHA/WhatsApp%20Image%202025-03-25%20at%2019.01.48_0243d255.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BAKE_O_MOCHA/WhatsApp%20Image%202025-03-25%20at%2019.01.49_92bebab5.jpg"
        ]
      },
      {
        "name": "Treepie",
        "time": "7:00 AM - 9:00 PM",
        "contact": "+91 9727757397",
        "location": "North Campus",
        "deliveryTime": "8:00 AM - 8:00 PM",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/la%20pinos/WhatsApp%20Image%202025-03-27%20at%2014.05.56_bfa92797.jpg"
        ],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/la%20pinos/WhatsApp%20Image%202025-03-25%20at%2019.08.41_0e986955.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/la%20pinos/WhatsApp%20Image%202025-03-25%20at%2019.08.41_25366ee3.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/la%20pinos/WhatsApp%20Image%202025-03-25%20at%2019.08.42_b0a191e2.jpg"
        ]
      },
      {
        "name": "Magpie",
        "time": "Not available",
        "contact": "Not available",
        "location": "South Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/MAgpie/WhatsApp%20Image%202025-03-23%20at%2016.36.22_684a55a8.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/MAgpie/WhatsApp%20Image%202025-03-23%20at%2016.36.31_ec68fb8e.jpg"
        ],
        "menu": [
          "https://github.com/Blackcoat123/vertex_photo/raw/main/IMG-20250216-WA0075.jpg",
          "https://github.com/Blackcoat123/vertex_photo/raw/main/IMG-20250216-WA0076.jpg"
        ]
      },
      {
        "name": "Griffon",
        "time": "Not available",
        "contact": "Not available",
        "location": "South Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/GRiffon/WhatsApp%20Image%202025-03-23%20at%2016.32.35_7eedff74.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/GRiffon/WhatsApp%20Image%202025-03-23%20at%2016.32.35_2306bdd8.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/GRiffon/WhatsApp%20Image%202025-03-23%20at%2016.32.35_e32c748a.jpg"
        ],
        "menu": [
          "https://github.com/Blackcoat123/vertex_photo/raw/main/IMG-20250216-WA0077.jpg",
          "https://github.com/Blackcoat123/vertex_photo/raw/main/IMG-20250216-WA0078.jpg"
        ]
      },
      {
        "name": "Bulbul",
        "time": "Not available",
        "contact": "Not available",
        "location": "South Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BUlbul/WhatsApp%20Image%202025-03-23%20at%2016.34.11_40d6c810.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/BUlbul/WhatsApp%20Image%202025-03-23%20at%2016.34.55_825ce056.jpg"
        ],
        "menu": [
          "https://github.com/Blackcoat123/vertex_photo/raw/main/IMG-20250216-WA0079.jpg",
          "https://github.com/Blackcoat123/vertex_photo/raw/main/IMG-20250216-WA0080.jpg"
        ]
      },
      {
        "name": "AMUL",
        "time": "9 am-12 pm",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/Amul/WhatsApp%20Image%202025-03-25%20at%2019.00.24_f0bae467.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/Amul/WhatsApp%20Image%202025-03-25%20at%2019.00.25_4f9c94a2.jpg"
        ],
        "menu": []
      },
      {
        "name": "D1 Shakes",
        "time": "Not available",
        "contact": "Not available",
        "location": "South Campus",
        "deliveryTime": "Not available",
        "images":[],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/D1/WhatsApp%20Image%202025-03-23%20at%2016.30.53_27fa1c10.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/D1/WhatsApp%20Image%202025-03-23%20at%2016.30.58_a6b5278d.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/D1/IMG-20250323-WA0013%5B1%5D.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/D1/IMG-20250323-WA0011%5B1%5D.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/D1/IMG-20250323-WA0010%5B1%5D.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/D1/IMG-20250323-WA0012%5B1%5D.jpg"
        ]
      },
      {
        "name": "The Mithran",
        "time": "9 am-9 pm",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/The%20DAIG/IMG_20250325_175309.jpg"
        ],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/The%20Mithran/WhatsApp%20Image%202025-03-25%20at%2019.00.26_8474ffd8.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/The%20Mithran/WhatsApp%20Image%202025-03-25%20at%2019.00.27_5f312361.jpg"
        ]
      },
      {
        "name": "The Diag",
        "time": "9 am-9 pm",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/The%20DAIG/IMG_20250325_175828.jpg"
        ],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/The%20DAIG/WhatsApp%20Image%202025-03-25%20at%2019.00.26_4bad436f.jpg"
        ]
      },
      {
        "name": "Trago (Higher Taste)",
        "time": "9 am-9 pm",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/TRAGO/IMG_20250325_174554.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/TRAGO/IMG_20250325_174700.jpg"
        ],
        "menu": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/TRAGO/WhatsApp%20Image%202025-03-25%20at%2019.00.27_ea306e7f.jpg"
        ]
      },
      {
        "name": "Fruit Shop",
        "time": "9 am-9 pm",
        "contact": "Not available",
        "location": "North Campus",
        "deliveryTime": "Not available",
        "images": [
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/Fruit%20shop/WhatsApp%20Image%202025-03-25%20at%2019.00.25_04586675.jpg",
          "https://github.com/Gamerboy2810/Appphotos/raw/main/App%20canteen%20pics/Fruit%20shop/WhatsApp%20Image%202025-03-25%20at%2019.00.26_fa1df9a9.jpg"
        ],
        "menu":[


      ]
    }
    ]
  };

  static List<Appointment> getAllDayEvents() {
    return [
      // January 2025
      Appointment(
        subject: "Classes Begin",
        startTime: DateTime(2025, 1, 17),
        endTime: DateTime(2025, 1, 17),
        isAllDay: true,
        color: Colors.deepPurple,
      ),
      Appointment(
        subject: "Republic Day",
        startTime: DateTime(2025, 1, 26),
        endTime: DateTime(2025, 1, 26),
        isAllDay: true,
        color: Colors.red,
      ),
      Appointment(
        subject: "Last date to Add/Drop courses",
        startTime: DateTime(2025, 1, 27),
        endTime: DateTime(2025, 1, 27),
        isAllDay: true,
        color: Colors.blueGrey,
      ),
      Appointment(
        subject: "Midsem TCF (upto 2nd March)",
        startTime: DateTime(2025, 2, 24),
        endTime: DateTime(2025, 2, 24),
        isAllDay: true,
        color: Colors.blueGrey,
      ),
      Appointment(
        subject: "Maha Shivaratri",
        startTime: DateTime(2025, 2, 26),
        endTime: DateTime(2025, 2, 26),
        isAllDay: true,
        color: Colors.orangeAccent,
      ),

      // March 2025
      Appointment(
        subject: "Mid-Sem Exams",
        startTime: DateTime(2025, 3, 3),
        endTime: DateTime(2025, 3, 6),
        isAllDay: true,
        color: Colors.deepPurple,
      ),
      Appointment(
        subject: "Holi",
        startTime: DateTime(2025, 3, 14),
        endTime: DateTime(2025, 3, 14),
        isAllDay: true,
        color: Colors.orangeAccent,
      ),
      Appointment(
        subject: "Mid-Sem Break",
        startTime: DateTime(2025, 3, 8),
        endTime: DateTime(2025, 3, 16),
        isAllDay: true,
        color: Colors.lightBlue,
      ),
      Appointment(
        subject: "Last Day for Showing/Seeing Answer Sheets",
        startTime: DateTime(2025, 3, 20),
        endTime: DateTime(2025, 3, 20),
        isAllDay: true,
        color: Colors.lightBlue,
      ),
      Appointment(
        subject: "Id-ul-Fitr",
        startTime: DateTime(2025, 3, 31),
        endTime: DateTime(2025, 3, 31),
        isAllDay: true,
        color: Colors.purple,
      ),

      Appointment(
        subject: "XPECTO",
        startTime: DateTime(2025, 3, 29),
        endTime: DateTime(2025, 3, 31),
        isAllDay: true,
        color: Colors.blueAccent.shade400,
      ),

      // April 2025
      Appointment(
        subject: "Mahavir Jayanti",
        startTime: DateTime(2025, 4, 10),
        endTime: DateTime(2025, 4, 10),
        isAllDay: true,
        color: Colors.orange,
      ),
      Appointment(
        subject: "Good Friday",
        startTime: DateTime(2025, 4, 18),
        endTime: DateTime(2025, 4, 18),
        isAllDay: true,
        color: Colors.brown,
      ),

      // May 2025
      Appointment(
        subject: "Final TCF Submission upto 15 May",
        startTime: DateTime(2025, 5, 5),
        endTime: DateTime(2025, 5, 5),
        isAllDay: true,
        color: Colors.purple,
      ),
      Appointment(
        subject: "Budh Purnima",
        startTime: DateTime(2025, 5, 5),
        endTime: DateTime(2025, 5, 5),
        isAllDay: true,
        color: Colors.orangeAccent,
      ),
      Appointment(
        subject: "Last Day of Teaching",
        startTime: DateTime(2025, 5, 14),
        endTime: DateTime(2025, 5, 14),
        isAllDay: true,
        color: Colors.teal,
      ),
      Appointment(
        subject: "End-Sem Exams",
        startTime: DateTime(2025, 5, 16),
        endTime: DateTime(2025, 5, 23),
        isAllDay: true,
        color: Colors.redAccent,
      ),
      Appointment(
        subject: "Annual Vacation",
        startTime: DateTime(2025, 5, 25),
        endTime: DateTime(2025, 7, 31),
        isAllDay: true,
        color: Colors.green,
      ),
      Appointment(
        subject: "Last Day for Showing Answer Sheets",
        startTime: DateTime(2025, 5, 27),
        endTime: DateTime(2025, 5, 27),
        isAllDay: true,
        color: Colors.lightBlue,
      ),
      Appointment(
        subject: "Grade Submission",
        startTime: DateTime(2025, 5, 29),
        endTime: DateTime(2025, 5, 29),
        isAllDay: true,
        color: Colors.purple,
      ),
      // June 2025
      Appointment(
        subject: "Summer Term Classes Begin",
        startTime: DateTime(2025, 6, 2),
        endTime: DateTime(2025, 6, 2),
        isAllDay: true,
        color: Colors.blueGrey,
      ),
      Appointment(
        subject: "Bakr-Id",
        startTime: DateTime(2025, 6, 7),
        endTime: DateTime(2025, 6, 7),
        isAllDay: true,
        color: Colors.brown,
      ),

      // July 2025
      Appointment(
        subject: "Muharram",
        startTime: DateTime(2025, 7, 6),
        endTime: DateTime(2025, 7, 6),
        isAllDay: true,
        color: Colors.brown,
      ),
      Appointment(
        subject: "Last Day of Teaching Summer Term",
        startTime: DateTime(2025, 7, 18),
        endTime: DateTime(2025, 7, 18),
        isAllDay: true,
        color: Colors.lightBlue,
      ),
      Appointment(
        subject: "Supplementary/Summer Exams",
        startTime: DateTime(2025, 7, 21),
        endTime: DateTime(2025, 7, 25),
        isAllDay: true,
        color: Colors.orangeAccent,
      ),
      Appointment(
        subject: "Grade Submission for Summer Exams",
        startTime: DateTime(2025, 7, 31),
        endTime: DateTime(2025, 7, 31),
        isAllDay: true,
        color: Colors.pinkAccent,
      ),

      // August 2025
      Appointment(
        startTime: DateTime(2025, 8, 1, 9, 0),
        endTime: DateTime(2025, 8, 1, 10, 0),
        subject: 'Classes Begin-Students report to FA',
        isAllDay: true,
      ),
      Appointment(
        startTime: DateTime(2025, 8, 11, 9, 0),
        endTime: DateTime(2025, 8, 11, 10, 0),
        subject: 'Last Date to Add/Drop Courses',
        color: Colors.teal,
        isAllDay: true,
      ),
      Appointment(
        startTime: DateTime(2025, 8, 16),
        endTime: DateTime(2025, 8, 16, 23, 59),
        subject: 'Janmashtami',
        color: Colors.deepOrange,
        isAllDay: true,
      ),
      Appointment(
        subject: "Independence Day",
        startTime: DateTime(2025, 8, 15),
        endTime: DateTime(2025, 8, 15),
        isAllDay: true,
        color: Colors.green,
      ),

      // September 2025
      Appointment(
        subject: "Mid-Sem TCF (upto 21st)",
        startTime: DateTime(2025, 9, 15),
        endTime: DateTime(2025, 9, 15),
        isAllDay: true,
        color: Colors.blueAccent,
      ),
      Appointment(
        subject: "Mid-Sem Exams",
        startTime: DateTime(2025, 9, 22),
        endTime: DateTime(2025, 9, 25),
        isAllDay: true,
        color: Colors.deepPurpleAccent,
      ),

      // October 2025
      Appointment(
        subject: "Gandhi Jayanti",
        startTime: DateTime(2025, 10, 2),
        endTime: DateTime(2025, 10, 2),
        isAllDay: true,
        color: Colors.lightGreen,
      ),
      Appointment(
          subject: "Dussera",
          startTime: DateTime(2025, 10, 2),
          endTime: DateTime(2025, 10, 2),
          isAllDay: true,
          color: Colors.deepOrange),
      Appointment(
        subject: "Mid-Sem Break",
        startTime: DateTime(2025, 10, 18),
        endTime: DateTime(2025, 10, 26),
        isAllDay: true,
        color: Colors.deepPurple,
      ),
      Appointment(
        subject: "Diwali",
        startTime: DateTime(2025, 10, 20),
        endTime: DateTime(2025, 10, 20),
        isAllDay: true,
        color: Colors.orange,
      ),

      // November 2025
      Appointment(
        subject: "Gurunanak Jayanti",
        startTime: DateTime(2025, 11, 5),
        endTime: DateTime(2025, 11, 5),
        isAllDay: true,
        color: Colors.yellow,
      ),
      Appointment(
        subject: "Final TCF Submission till 28th",
        startTime: DateTime(2025, 11, 17),
        endTime: DateTime(2025, 11, 17),
        isAllDay: true,
        color: Colors.brown,
      ),
      Appointment(
        subject: "Last Day of Teaching",
        startTime: DateTime(2025, 11, 26),
        endTime: DateTime(2025, 11, 26),
        isAllDay: true,
        color: Colors.teal,
      ),

      // December 2025
      Appointment(
        subject: "Winter Vacations",
        startTime: DateTime(2025, 12, 8),
        endTime: DateTime(2025, 12, 31),
        isAllDay: true,
        color: Colors.green,
      ),
      Appointment(
        subject: "Christmas",
        startTime: DateTime(2025, 12, 25),
        endTime: DateTime(2025, 12, 25),
        isAllDay: true,
        color: Colors.blue,
      ),
    ];
  }
}
