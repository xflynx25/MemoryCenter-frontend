import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: SingleChildScrollView( // Use SingleChildScrollView to enable scrolling
        padding: EdgeInsets.all(16.0), // Add some padding around the content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
          children: <Widget>[
            Text(
              'App Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8), // Add some spacing
            Text(
              'This is a method for memorization inspired by the kgb methods for language learning. Improving the memorization process can very useful beyond just learning languages, though. I set out to solve 2 main problems with other apps like Goodnotes or Quizlet: (1) Input time should be as small and simple as possible (2) The user should not have to worry about inventing/managing the study process. The aim is for this memory center to help sit as an HDD for your memory. You write in what you would like to memorize, and train efficiently to load into your brain when you would like. The training method will also give you feedback on what you actually have memorized, and what needs work.',
            ),
            SizedBox(height: 16), // Add more spacing

            Text(
              'Data Model',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'The organization of data is into Collections, Topics, and Items. Collections are a coherent subject area you want to increase your memory of. Topics are subgroupings of this general area. Items are individual atoms for you to memorize. As an example, if you want to learn german, you could make a collection called German, several topics such as letters, family, swear words, verbs, etc. And each of these would have a set of items inside of it. You can toggle on which topics you want to study at a time.',
            ),
            SizedBox(height: 16),

            Text(
              'Studying',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'To study, you press the play button. You can have it give you the front or the back, or a probability distribution by the slider. You are self scoring, so if you get it right, then swipe right, if you get it wrong, swipe left. Up or down to flip the card over. The database will advance you a level if correct, drop you down if wrong. If you want to move to the last level, you will need to get it right on multiple days in a row, without failure. One failure will set you back. Then you can "retire" the card -- but only for so long, it will drop out after a while.',
            ),
            SizedBox(height: 16),

            Text(
              'Future Features to Look Out For',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Friends, sharing collections and topics with friends, both for viewing/playing as well as creation. Leaderboards, scoreboards, team studying, etc.',
            ),
            SizedBox(height: 16),

            // Add more sections as needed
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Why it is not sending through? ANS:::: there are max lengths. Currently, 50 chars for topic/collection titles, 100 chars for a front/back of a card.',
            ),
            // ... more content as needed
          ],
        ),
      ),
    );
  }
}
