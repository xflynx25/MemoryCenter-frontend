import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';


import 'services/auth_service.dart';
import 'pages/register_page.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/help_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_collection_page.dart';
import 'pages/edit_topic_page0.dart';
import 'pages/edit_topic_page1.dart';
import 'pages/edit_topic_page2.dart';
import 'pages/play_page.dart';


import 'models/collection.dart';
import 'models/topic.dart';

import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'dart:developer' as developer;
import 'package:logging/logging.dart';
final _logger = Logger('MainLogging');



void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures plugin services are initialized.

  // FIREBASE TOOLS

  if (kIsWeb) {

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCoiiGnhtU22eMB8Hvi3KRlmJTKi-35rT4",
      authDomain: "memorycenter00.firebaseapp.com",
      projectId: "memorycenter00",
      storageBucket: "memorycenter00.appspot.com",
      messagingSenderId: "404428894029",
      appId: "1:404428894029:web:cc9a80d13a8517565c9104",
      measurementId: "G-8TDYK940L9"
    ),
  );
  }
  
  // Initialize logger, debug prints etc.
  _initializeLogging();

  // Load the .env file
  await dotenv.load(fileName: ".env"); // Specify the .env file name

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
}

void _initializeLogging() {

  // just many print methods for debugging in case some stop working
  developer.log('log me', name: 'my.app');
  debugPrint('DEBUG');
  Logger.root.level = Level.ALL; // This will log all messages
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  print('hugachaka');
  _logger.info('MAIN');
  _logger.warning('MAIN');
  _logger.severe('MAIN');
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'JWT Auth',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => LoginPage());
        } else if (settings.name == '/register') {
          return MaterialPageRoute(
              builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('Register'),
                    ),
                    body: RegisterForm(),
                  ));
        } else if (settings.name == '/home') {
          return MaterialPageRoute(builder: (context) => HomePage());
        } else if (settings.name == '/help') {
            return MaterialPageRoute(builder: (context) => HelpPage());
          }else if (settings.name == '/profile') {
          final int userId = settings.arguments as int;
          return MaterialPageRoute(builder: (context) => ProfilePage(userId: userId));
        } else if (settings.name == '/edit_topic0') {
          final Topic topic = settings.arguments as Topic;
          return MaterialPageRoute(builder: (context) => EditTopicPage0(topic: topic));
        } else if (settings.name == '/edit_topic1') {
          final Topic topic = settings.arguments as Topic;
          return MaterialPageRoute(builder: (context) => EditTopicPage1(topic: topic));
        } else if (settings.name == '/edit_topic2') {
          final Topic topic = settings.arguments as Topic;
          return MaterialPageRoute(builder: (context) => EditTopicPage2(topic: topic));
        } else if (settings.name == '/edit_collection') {
          final Map arguments = settings.arguments as Map;
          final Collection collection = arguments['collection'];
          final futureTopics = arguments['topics'];
          futureTopics.then((topics) {
            _logger.warning('Number of topics: ${topics.length}');
          });
          return MaterialPageRoute(builder: (context) => EditCollectionPage(collection: collection, futureTopics: futureTopics));
        }
        else if (settings.name == '/play_page') {
          if (settings.arguments != null) {
            final Map arguments = settings.arguments as Map;
            final Collection collection = arguments['collection'] as Collection;
            return MaterialPageRoute(builder: (context) => PlayPage(collection: collection));
          } else {
            // Handle the case when arguments is null, e.g., navigate to an error page
          }
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
