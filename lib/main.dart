import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';
import 'loading.dart';
import 'user.dart';
import 'user_service.dart';
import 'topic.dart';
import 'collection.dart';
import 'collection_service.dart';
import 'topic_service.dart';
import 'dart:developer' as developer;

import 'package:logging/logging.dart';
final _logger = Logger('MainLogging');



void main() {
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    _logger.info('LOGINFORM');
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Username'),
            onSaved: (value) => _username = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value!,
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              showDialog(
                context: context,
                builder: (context) => Loading(),
              );
              bool success = await Provider.of<AuthService>(context, listen: false)
                  .login(_username, _password);
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                // Show error message
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Login failed')));
              }
            },
            child: Text('Login'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('Register'),
                  ),
                  body: RegisterForm(),
                )),
              );
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    _logger.info('RESISTERFORM');
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Username'),
            onSaved: (value) => _username = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            onSaved: (value) => _password = value!,
          ),
          ElevatedButton(
            onPressed: () async {
              _formKey.currentState!.save();
              showDialog(
                context: context,
                builder: (context) => Loading(),
              );
              bool success = await Provider.of<AuthService>(context, listen: false)
                  .register(_username, _password);
              Navigator.pop(context); // Pop the loading dialog
              if (success) {
                Navigator.pop(context); // Pop the registration page
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Registration failed')));
              }
            },
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}

class DataFutureBuilder<T> extends StatelessWidget {
  final Future<List<T>> future;
  final Widget Function(BuildContext, List<T>) dataBuilder;

  const DataFutureBuilder({
    Key? key,
    required this.future,
    required this.dataBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _logger.info('FUTURE_BUILDER');
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        _logger.info("Snapshot state: ${snapshot.connectionState}");
        if (snapshot.hasData) {
          _logger.info("Snapshot data: ${snapshot.data}");
          return dataBuilder(context, snapshot.data!);
        } else if (snapshot.hasError) {
          _logger.info("Snapshot error: ${snapshot.error}");
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator();
      },

    );
  }
}



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
                // Navigate to Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(userId: users[index].id),
                  ),
                );
              },
            );
          },
        );
      },
    ),
  );
} }


class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Topic>> futureTopics;
  late Future<List<Collection>> futureCollections;

  @override
  void initState() {
    _logger.info('PROFILEPAGEINIT');
    super.initState();
    futureTopics = TopicService().getAllTopics(widget.userId);
    futureCollections = CollectionService().getAllCollections(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('PROFILEPAGE');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: DataFutureBuilder(
              future: futureTopics,
              dataBuilder: (BuildContext context, List<Topic> topics) {
                return ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(topics[index].topicName),
                      subtitle: Text(topics[index].description ?? ''),
                      onTap: () {
                        // Implementation when a topic is tapped
                      },
                    );
                  },
                );
              }
            ),
          ),
          Expanded(
            child: DataFutureBuilder(
              future: futureCollections,
              dataBuilder: (BuildContext context, List<Collection> collections) {
                return ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(collections[index].collectionName),
                      subtitle: Text(collections[index].description ?? ''),
                      onTap: () {
                        // Implementation when a collection is tapped
                      },
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
