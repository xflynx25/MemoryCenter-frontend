import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

import 'package:logging/logging.dart';
final _logger = Logger('MainLogger');

void main() {
  _setupLogging();
  _logger.info('Starting the application');
  runApp(MaterialApp(home: MyApp()));
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // Log all messages
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}


class MyApp extends StatefulWidget {
    @override
    _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

Future<List<User>> _getUsers() async {
  var url = Uri.parse("${Config.HOST}/api/users/");
  _logger.info('Sending request to: $url');

  try {
    var response = await http.get(url);
    _logger.info('Response status: ${response.statusCode}');
    _logger.info('Response body: ${response.body}');

    var jsonData = json.decode(response.body);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["username"], u["password"], u["favorite_color"]);
      // Provide a default value of null for favorite_color if it's not present in the JSON
      users.add(user);
    }

    return users;

  } catch (e) {
    _logger.severe('Caught error: $e');
    rethrow;
  }
}


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('User List'),
            ),
            body: Container(
                child: FutureBuilder(
                  future: _getUsers(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),  // consider using a loading spinner for better UX
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),  // now if there's an error, it will be shown in the UI
                      );
                    } else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    title: Text(snapshot.data[index].username),
                                    subtitle: Text("Favorite Color: " + snapshot.data[index].favoriteColor),
                                );
                            },
                        );
                    }
                  },
                ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewUser()),
                );
              },
              child: Icon(Icons.add),
            ),
        );
    }
}

class User {
    final String username;
    final String password;
    final String favoriteColor;

    User(this.username, this.password, this.favoriteColor);
}

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                hintText: "Username"
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password"
              ),
            ),
            TextField(
              controller: colorController,
              decoration: InputDecoration(
                hintText: "Favorite Color"
              ),
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () async {
                var response = await http.post(Uri.parse("${Config.HOST}/api/users/"),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, String>{
                    'username': usernameController.text,
                    'password': passwordController.text,
                    'favorite_color': colorController.text,
                  }),
                );
                print(response.body);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

