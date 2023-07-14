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
  String search = '';
  
  void refreshData() {
    setState(() {
    futureUsers = UserService().getAllUsers();
    });
  }

  @override
  void initState() {
    _logger.info('HOMEPAGEINIT');
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('HOMEPAGESTATE');
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: UserSearch(users: futureUsers),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: FutureBuilder<List<User>>(
                      future: futureUsers,
                      builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return Text(snapshot.data![0].username[0]);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  title: FutureBuilder<List<User>>(
                    future: futureUsers,
                    builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Text(snapshot.data![0].username);
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.width * 0.25, // 50% of screen width
                width: MediaQuery.of(context).size.width * 0.25, // 50% of screen width
                child: Image.asset(
                  'assets/welcome_picture.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),


            Text('Users', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),

            DataFutureBuilder<User>(
              future: futureUsers,
              dataBuilder: (BuildContext context, List<User> users) {
                final filteredUsers = users.where((user) => user.username.startsWith(search)).toList();
                return ListView.builder(
                  shrinkWrap: true,  // use this to give the ListView a size based on its children
                  physics: NeverScrollableScrollPhysics(),  // this disables the scrolling for this ListView so you don't get 'scrolling within scrolling'
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5, // 50% of screen width
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              title: Text(filteredUsers[index].username),
                              subtitle: Text(filteredUsers[index].realname ?? ''),
                              onTap: () async { await Navigator.pushNamed(context, '/profile', arguments: filteredUsers[index].id);
                                  refreshData();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  final Future<List<User>> users;

  UserSearch({required this.users});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<User>>(
      future: users,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        final results = snapshot.data!
            .where((user) => user.username.startsWith(query));

        return ListView(
          children: results.map<ListTile>((user) {
            return ListTile(
              title: Text(user.username),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: user.id,  // Pass userId as argument
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
