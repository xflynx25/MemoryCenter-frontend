import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/edit_collection_page.dart';
import 'pages/edit_topic_page0.dart';
import 'pages/edit_topic_page1.dart';
import 'pages/edit_topic_page2.dart';

import 'models/collection.dart';
import 'models/topic.dart';

import 'dart:developer' as developer;
import 'package:logging/logging.dart';
final _logger = Logger('MainLogging');

void main() {

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

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MyApp(),
    ),
  );
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
        } else if (settings.name == '/profile') {
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
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
