import 'package:flutter/material.dart';
class Config {
  static const HOST = 'http://127.0.0.1:8000';
  static const MAX_ITEMS_IN_TOPIC = 10000;
  static const EDIT_TOPIC_0_BLANK_ITEMS = 10;
  
  // static instead of const
  static final List<Color> SCORE_COLORS = [
    Colors.blue.shade50,  // Score 0
    Colors.blue.shade100, // Score 1
    Colors.blue.shade200, // Score 2
    Colors.blue.shade300, // Score 3
    Colors.blue.shade400, // Score 4
    Color.fromARGB(255, 236, 218, 84), // Score 5
  ];

  // static instead of const
  static final List<String> SCORE_TEXTS = [
    "0", "1", "2", "3", "4", "S", 
  ];
}

