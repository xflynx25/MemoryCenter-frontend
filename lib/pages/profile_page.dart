import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/collection.dart';
import '../models/user.dart';
import '../services/topic_service.dart';
import '../services/collection_service.dart';
import '../services/user_service.dart';
import '../widgets/data_future_builder.dart';
import '../utils/config.dart';
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

  final _topicNameController = TextEditingController();
  final _topicDescriptionController = TextEditingController();
  
  final _collectionNameController = TextEditingController();
  final _collectionDescriptionController = TextEditingController();
  
  @override
  void dispose() {
    _topicNameController.dispose();
    _topicDescriptionController.dispose();
    _collectionNameController.dispose();
    _collectionDescriptionController.dispose();
    super.dispose();
  }

  void refreshData() {
    setState(() {
      futureUser = UserService().getUser(widget.userId);
      futureTopics = TopicService().getAllTopics(widget.userId);
      futureCollections = CollectionService().getAllCollections(widget.userId);
    });
  }

  @override
  void initState() {
    _logger.info('PROFILEPAGEINIT');
    super.initState();
    refreshData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: FutureBuilder<User>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text('Profile (${snapshot.data!.username})');
              }
            },
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // This is called when the user presses the AppBar back button
              // Refresh the data here too
              refreshData();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<User>(
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
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        for (int i = 0; i < Config.SCORE_COLORS.length; i++)
                          Expanded(
                            child: ListTile(
                              leading: Container(
                                width: 24,
                                height: 24,
                                color: Config.SCORE_COLORS[i],
                              ),
                              title: Text(Config.SCORE_TEXTS[i]),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add, color: Colors.transparent), // Invisible Icon
                  onPressed: () {},
                ),
                Spacer(),
                Text('Collections', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Create a new Collection'),
                          content: Column(
                            children: <Widget>[
                              Container(
                                width: 200, // Adjust width as needed
                                child: TextField(
                                  controller: _collectionNameController,
                                  decoration: InputDecoration(hintText: "Enter collection name"),
                                ),
                              ),
                              Container(
                                width: 200, // Adjust width as needed
                                child: TextField(
                                  controller: _collectionDescriptionController,
                                  decoration: InputDecoration(hintText: "Enter description"),
                                ),
                              ),
                              // Add more fields if needed
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Confirm'),
                              onPressed: () async {
                                // Call createCollection function and pass the input values
                                var success = await CollectionService().createCollection(
                                  _collectionNameController.text,
                                  _collectionDescriptionController.text,
                                  'private', //visibility just defaulting rn
                                );
                                if(success) { //If newCollection is created successfully.
                                  Navigator.of(context).pop(); //Close the dialog
                                  refreshData();
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Spacer(),
              ],
            ),

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
                        width: MediaQuery.of(context).size.width * 0.6,
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
                                        itemCount: collections[index].collectionTopics.length,
                                        itemBuilder: (BuildContext context, int innerIndex) {
                                          return ListTile(
                                            tileColor: collections[index].collectionTopics[innerIndex].isActive 
                                                      ? Colors.green.withOpacity(0.2)   // light green for active
                                                      : Colors.red.withOpacity(0.2),    // light red for inactive
                                            title: Text(collections[index].collectionTopics[innerIndex].topicName),
                                            subtitle: Text(collections[index].collectionTopics[innerIndex].isActive ? 'Active' : 'Inactive'),
                                            onTap: () {
                                              // Implementation when a topic is tapped
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                (collections[index].visibility == 'private' || collections[index].visibility == 'global_edit')
                                ? Row(
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () async {
                                          await Navigator.pushNamed(
                                            context, 
                                            '/edit_collection', 
                                            arguments: {
                                              'collection': collections[index], 
                                              'topics': futureTopics
                                            }
                                          );
                                          refreshData();
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          final confirm = await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Confirm'),
                                                content: const Text('Are you sure you want to delete this collection?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: const Text('DELETE'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: const Text('CANCEL'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          if (confirm) {
                                            final success = await CollectionService().deleteCollection(collections[index].id);
                                            if (success) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Collection deleted successfully')),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Failed to delete collection')),
                                              );
                                            }
                                            refreshData();
                                          }
                                        },
                                      ),
                                      // Add play button next to edit and delete buttons
                                      IconButton(
                                        icon: const Icon(Icons.play_arrow),  // Play icon
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context, 
                                            '/play_page', 
                                            arguments: {'collection': collections[index]}
                                          );
                                          refreshData();
                                        },
                                      ),

                                    ],
                                  )
                                : Container(),
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



              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.transparent), // Invisible Icon
                    onPressed: () {},
                  ),
                  Spacer(),
                  Text('Topics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Create a new Topic'),
                            content: Column(
                              children: <Widget>[
                                Container(
                                  width: 200, // Adjust width as needed
                                  child: TextField(
                                    controller: _topicNameController,
                                    decoration: InputDecoration(hintText: "Enter topic name"),
                                  ),
                                ),
                                Container(
                                  width: 200, // Adjust width as needed
                                  child: TextField(
                                    controller: _topicDescriptionController,
                                    decoration: InputDecoration(hintText: "Enter description"),
                                  ),
                                ),
                                // Add more fields if needed
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Confirm'),
                                onPressed: () async {
                                  // Call createTopic function and pass the input values
                                  var success = await TopicService().createTopic(
                                    _topicNameController.text,
                                    _topicDescriptionController.text,
                                    'private', //visibility just defaulting rn
                                  );
                                  if(success) { //If newTopic is created successfully.
                                    Navigator.of(context).pop(); //Close the dialog
                                    refreshData();
                                  }
                                },
                              ),

                            ],
                          );
                        },
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),

            
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
                                            tileColor: Config.SCORE_COLORS[topics[index].items[innerIndex].score],
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
                              ? Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                          await Navigator.pushNamed(context, '/edit_topic0', arguments: topics[index]);
                                          refreshData();
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        final confirm = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirm'),
                                              content: const Text('Are you sure you want to delete this topic?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text('DELETE'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: const Text('CANCEL'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm) {
                                          final success = await TopicService().deleteTopic(topics[index].id);
                                          if (success) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Topic deleted successfully')),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to delete topic')),
                                            );
                                          }
                                          refreshData();
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : Container(),
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


          ],
        ),
      ),
    );
  }
}