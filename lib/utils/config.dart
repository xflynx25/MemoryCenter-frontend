import 'package:flutter/material.dart';
class Config {
  //static String get HOST => dotenv.env['HOST'] ?? 'http://127.0.0.1:8000'; // localhost if we don't provide host
  //static const HOST = 'http://127.0.0.1:8000';
  static const HOST = 'http://0.0.0.0:8000'; 
  //static const HOST = 'https://memory-center-backend-0c697b5afd37.herokuapp.com';
  static const MAX_ITEMS_IN_TOPIC = 10000;
  static const EDIT_TOPIC_0_BLANK_ITEMS = 10;
  static const FETCH_NUMBER = 20; // how many to fetch at a time
  static const FETCH_INTERVAL = 10; // bad name, it is how many seconds you send the scores  
  static const FETCH_AT_HOW_MANY_LEFT = 1; // how many left when you fetch new ones (you will get repeats of whatever you just studied and score hasn't been updated) tradeoff of loading screen vs repeats
  
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

