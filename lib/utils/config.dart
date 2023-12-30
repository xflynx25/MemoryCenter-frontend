
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  static const DEBUG = false; // Set to false in production

  // API backends
  static const String DEFAULT_API_BACKEND = 'http://127.0.0.1:8000';
  static const String PRODUCTION_API_BACKEND = 'https://memory-center-backend-0c697b5afd37.herokuapp.com';
  static const String ANDROID_API_BACKEND = 'http://10.0.2.2:8000';
  static const String IOS_API_BACKEND = 'http://localhost:8000';
  static const String WEB_API_BACKEND = 'http://localhost:8000';

  // Gets the appropriate API backend based on platform and debug mode
  static String get HOST {
    if (DEBUG) {
      if (kIsWeb) {
        return WEB_API_BACKEND;
      } else if (Platform.isAndroid) {
        return ANDROID_API_BACKEND;
      } else if (Platform.isIOS) {
        return IOS_API_BACKEND;
      }
    }
    return PRODUCTION_API_BACKEND;
  }

  static const MAX_ITEMS_IN_TOPIC = 10000;
  static const EDIT_TOPIC_0_BLANK_ITEMS = 10;
  static const N_ZERO = 10; //for fetching at a time
  static const N_OLD = 10;  //for fetching at a time
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
