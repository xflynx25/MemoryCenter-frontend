import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/collection.dart';
import '../models/user.dart';
import '../services/topic_service.dart';
import '../services/collection_service.dart';
import '../services/user_service.dart';
import '../widgets/data_future_builder.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/config.dart';
import 'package:logging/logging.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



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

  final List<String> visibilityOptions = ['private', 'global_view'];
  String _selectedVisibility = 'private'; // default value
  String _selectedTopicVisibility = 'private'; // default value for topic visibility

  int? _loggedInUserId; // State variable for logged-in user ID

  Future<int?> get loggedInUserId async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getInt('loggedInUserId');
  }

  void _fetchLoggedInUserId() async {
    _loggedInUserId = await loggedInUserId;
    setState(() {}); // Update the state to reflect changes
  }

  @override
  void initState() {
    _logger.info('PROFILEPAGEINIT');
    super.initState();
    _fetchLoggedInUserId();
    refreshData();
  }

  
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



  

  void _showAddDialog({
  required String title,
  required TextEditingController nameController,
  required TextEditingController descriptionController,
  required Future<bool> Function(String, String, String) createFunction,
  required String initialGroupValue,
}) {
  String localGroupValue = initialGroupValue;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "Enter name"),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(hintText: "Enter description"),
                  ),
                  ...visibilityOptions.map((String value) {
                    return RadioListTile<String>(
                      title: Text(value),
                      value: value,
                      groupValue: localGroupValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          localGroupValue = newValue!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            );
          },
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
              var success = await createFunction(
                nameController.text,
                descriptionController.text,
                localGroupValue,
              );
              if (success) {
                Navigator.of(context).pop();
                refreshData();
              }
            },
          ),
        ],
      );
    },
  );
}

void _showAddCollectionDialog() {
  _showAddDialog(
    title: 'Create a new Collection',
    nameController: _collectionNameController,
    descriptionController: _collectionDescriptionController,
    createFunction: CollectionService().createCollection,
    initialGroupValue: _selectedVisibility,
  );
}

void _showAddTopicDialog() {
  _showAddDialog(
    title: 'Create a new Topic',
    nameController: _topicNameController,
    descriptionController: _topicDescriptionController,
    createFunction: TopicService().createTopic,
    initialGroupValue: _selectedTopicVisibility,
  );
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: loggedInUserId, // This is your async operation
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator while data is loading
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
        } else {
          _loggedInUserId = snapshot.data; // Update the state variable with the fetched user ID
          return _buildPageContent(); // Build the page content using the fetched data
        }
      },
    );
  }

Widget _buildPageContent() {
    return Scaffold(
        appBar: CustomAppBar(
      title: 'Profile',
      showBackButton: true,
      onBackButtonPressed: () {
        refreshData();
        Navigator.of(context).pop();
      },
      actions: [
        // ... your other action widgets
      ],
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
                          return FractionallySizedBox(
                            widthFactor: 0.5, // 50% of the screen width
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(snapshot.data!.username[0]),
                              ),
                              title: Text(snapshot.data!.username),
                              subtitle: Text(snapshot.data!.realname ?? ''),
                            ),
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
                            child: FractionallySizedBox(
                              widthFactor: 1, // For example, 25% of the available space
                              child: ListTile(
                                leading: Container(
                                  width: 24,
                                  height: 24,
                                  color: Config.SCORE_COLORS[i],
                                ),
                                title: Text(Config.SCORE_TEXTS[i]),
                              ),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: Text('Collections', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),

                (_loggedInUserId != null && widget.userId == _loggedInUserId) ? 
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _showAddCollectionDialog,
                  ) 
                : Container(),

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
                                (_loggedInUserId != null && (collections[index].user == _loggedInUserId || collections[index].visibility == 'global_edit'))
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


                 (_loggedInUserId != null && widget.userId == _loggedInUserId) ? 
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _showAddTopicDialog,
                  )
                  : Container(),

                  Spacer(),
                ],
              ),

            
            DataFutureBuilder<Topic>(
              future: futureTopics,
              dataBuilder: (BuildContext context, List<Topic> topics) {
                _logger.warning('IN ITEMBUILDER OF TOPICS');
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


                              (_loggedInUserId != null && (topics[index].user == _loggedInUserId || topics[index].visibility == 'global_edit'))
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