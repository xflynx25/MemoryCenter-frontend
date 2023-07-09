import '../services/topic_service.dart';
import '../widgets/data_future_builder.dart';
import 'package:flutter/material.dart';
import '../models/topic.dart';
import '../models/collection.dart';
import '../services/collection_service.dart';
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
