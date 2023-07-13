import 'package:flutter/material.dart';
import '../models/item.dart';


class ItemsScreen extends StatelessWidget {
  final List<Item> all_items;

  ItemsScreen({required this.all_items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
      ),
      body: ListView.builder(
        itemCount: all_items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(all_items[index].front),
            subtitle: Text(all_items[index].back),
            onTap: () {
              // Implementation when an item is tapped
            },
          );
        },
      ),
    );
  }
}
