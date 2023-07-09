import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import './pages/home_page.dart';
import 'pages/profile_page.dart';

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
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
