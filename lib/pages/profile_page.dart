import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/collection.dart';
import '../models/user.dart';
import '../services/topic_service.dart';
import '../services/collection_service.dart';
import '../services/user_service.dart';
import '../widgets/data_future_builder.dart';
import 'package:logging/logging.dart';

final _logger = Logger('PROFILEPAGE_Logging');

class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Topic>> futureTopics;
  late Future<List<Collection>> futureCollections;
  late Future<User> futureUser;

  @override
  void initState() {
    _logger.info('PROFILEPAGEINIT');
    super.initState();
    futureTopics = TopicService().getAllTopics(widget.userId);
    futureCollections = CollectionService().getAllCollections(widget.userId);
    futureUser = UserService().getUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    _logger.info('PROFILEPAGE');
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(snapshot.data!.username[0]),
                    ),
                    title: Text(snapshot.data!.username),
                    subtitle: Text(snapshot.data!.realname ?? ''),
                  );
                }
              },
            ),

            Text('Topics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),

            
            DataFutureBuilder<Topic>(
              future: futureTopics,
              dataBuilder: (BuildContext context, List<Topic> topics) {
                _logger.warning('IN ITEMBUILDER OF TOPICS');
                _logger.warning(topics[0]);
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6, // Adjust to fit the IconButton
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ExpansionTile(
                                    title: Text(topics[index].topicName),
                                    children: <Widget>[
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: topics[index].items.length,
                                        itemBuilder: (BuildContext context, int innerIndex) {
                                          return ListTile(
                                            title: Text(topics[index].items[innerIndex].front),
                                            subtitle: Text(topics[index].items[innerIndex].back),
                                            onTap: () {
                                              // Implementation when an item is tapped
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                (topics[index].visibility == 'private' || topics[index].visibility == 'global_edit') 
                                  ? IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/edit_topic0', arguments: topics[index]);
                                      },
                                    )
                                  : Container(),  // Empty container for when the IconButton is not displayed
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),




            Text('Collections', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),

            DataFutureBuilder<Collection>(
              future: futureCollections,
              dataBuilder: (BuildContext context, List<Collection> collections) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: collections.length,
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
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ExpansionTile(
                              title: Text(collections[index].collectionName),
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: collections[index].topics.length,
                                  itemBuilder: (BuildContext context, int innerIndex) {
                                    return ListTile(
                                      title: Text(collections[index].topics[innerIndex].topicName),
                                      subtitle: Text(collections[index].topics[innerIndex].description ?? ''),
                                      onTap: () {
                                        // Implementation when a topic is tapped
                                      },
                                    );
                                  },
                                )
                              ]
                                ),),
                                (collections[index].visibility == 'private' || collections[index].visibility == 'global_edit') 
                                  ? IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/edit_collection', arguments: collections[index]);
                                      },
                                    )
                                  : Container(),  // Empty container for when the IconButton is not displayed
                              ],
                            ),
                          )
                        )
                      )
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