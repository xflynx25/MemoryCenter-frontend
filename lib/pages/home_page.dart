import '../models/user.dart';
import '../services/user_service.dart';
import '../widgets/data_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
final _logger = Logger('HOMEPAGE_Logging');

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    _logger.info('HOMEPAGEINIT');
    super.initState();
    futureUsers = UserService().getAllUsers();
  }

  @override
Widget build(BuildContext context) {
    _logger.info('HOMEPAGESTATE');
  return Scaffold(
    appBar: AppBar(
      title: Text('Home'),
    ),
    body: DataFutureBuilder<User>(
      future: futureUsers,
      dataBuilder: (BuildContext context, List<User> users) {
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].username),
              subtitle: Text(users[index].realname ?? ''),
              onTap: () {
                  // Navigate to Profile Page using routes
                  Navigator.pushNamed(
                    context,
                    '/profile',
                    arguments: users[index].id,  // Pass userId as argument
                  );
                },
            );
          },
        );
      },
    ),
  );
} 
}
