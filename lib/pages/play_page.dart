import 'package:MemoryCenter_frontend/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/collection.dart';
import '../models/card_item.dart';
import '../services/collection_service.dart';
import 'dart:async';
import '../models/outbox.dart';
import '../services/score_service.dart';
import '../widgets/loading.dart';
import 'package:logging/logging.dart';
import 'dart:math';


final _logger = Logger('PlayPageLogging');

class PlayPage extends StatefulWidget {
  final Collection collection;

  PlayPage({Key? key, required this.collection}) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with TickerProviderStateMixin {
  List<CardItem> cardItems = [];
  int currentIndex = 0; 
  bool showFront = true; 
  bool errorOccurred = false;
  String errorMessage = '';
  Outbox outbox = Outbox();
  Timer? updateTimer;
  ScoreService scoreService = ScoreService();
  late AnimationController _rightController;
  late Animation<Offset> _rightAnimation;
  late AnimationController _leftController;
  late Animation<Offset> _leftAnimation;
  bool nextShowFront = true;
  double frontStartChance = 1.0;  // All cards start on the front by default.
  final random = Random();  // For randomizing the card side.
  final sliderFocusNode = FocusNode();


  void _addScore(int itemId, int increment) {
    outbox.addScore(itemId, increment);
    _logger.info('Added score $increment for item $itemId');
  }
    
void changeCard(int change) {
  if (cardItems.length > 0) {
    var item = cardItems.removeAt(0);
    outbox.addScore(item.id, change); // Here
  }
  if (cardItems.length == Config.FETCH_AT_HOW_MANY_LEFT) {  // If there's only 1 card left, fetch new cards
    _fetchCardItems();
  }
  setState(() {
    showFront = nextShowFront;
    nextShowFront = random.nextDouble() <= frontStartChance;
  });
}



  @override
  void initState() {
    super.initState();
    showFront = random.nextDouble() <= frontStartChance;  // Randomize showFront at the start.
    _fetchCardItems();

    _rightController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _rightController.reset();
          changeCard(1);  // positive score for right swipe
        }
      });

    _rightAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _rightController,
      curve: Curves.linear,
    ));

    _leftController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _leftController.reset();
          changeCard(-1);  // negative score for left swipe
        }
      });

    _leftAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _leftController,
      curve: Curves.linear,
    ));

    


    updateTimer = Timer.periodic(Duration(seconds: Config.FETCH_INTERVAL), (timer) {
      _updateScores();
    });
  }

  Future<void> _updateScores() async {
    var scoresMap = outbox.flush();
    _logger.info('Updating scores: $scoresMap');
    if (scoresMap.isNotEmpty) {
      // Convert Map<int, int> to List<Map<String, int>>
      List<Map<String, int>> scoresList = scoresMap.entries
          .map((e) => {'item_id': e.key, 'increment': e.value})
          .toList();
      try {
        var response = await scoreService.updateScores(scoresList);
        if (response['status'] == 'success') {
          _logger.info('Scores updated successfully');
        } else {
          _logger.severe('Failed to update scores: $response');
        }
      } catch (e) {
        _logger.severe('Failed to update scores: $e');
      }
    }
  }


  @override
  void dispose() {
    updateTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _updateScores();
    });
    super.dispose();
    _rightController.dispose();
    _leftController.dispose();
  }

  Future<void> _fetchCardItems() async {
    // Ensure scores are updated before fetching new card items to minimize repeats
    await _updateScores();

    // Determine the number of cards to remove from the fetched items, and remove, to avoid duplication
    // should work unless we get in an update scores before the fetch N, in which case all that will happen is we will throw away things we could have studied, that's ok
    int numCardsToRemove = cardItems.length;

    _logger.info('Fetching card items for collection ${widget.collection.id}');
      try {
          List<CardItem> fetchedCardItems = await CollectionService().fetchNFromCollection(
                widget.collection.id, Config.N_OLD, Config.N_ZERO
              );      

      // remove the duplicate
      if (numCardsToRemove > 0 && fetchedCardItems.isNotEmpty) {
        fetchedCardItems = fetchedCardItems.sublist(numCardsToRemove);
      }

      if (fetchedCardItems.isEmpty && cardItems.isEmpty) {
        setState(() {
          errorMessage = 'No card items found for this collection.';
        });
      } else {
        // Shuffle the fetched card items before appending
        fetchedCardItems.shuffle(random); // Use the existing random object for shuffling

        setState(() {
          cardItems.addAll(fetchedCardItems); // Append shuffled new items to existing ones
        });
      }
      _logger.info('Fetched card items: $fetchedCardItems');
    } catch (e) {
      _logger.warning(e);
      // Determine the error based on the error message.
      if (e.toString().contains("No More Items")) {
        setState(() {
          errorOccurred = true;
          errorMessage = 'No More Items';
        });
      } else {
        setState(() {
          errorOccurred = true;
          errorMessage = 'An error occurred while fetching the card items.';
        });
      }
      _logger.severe('Error occurred while fetching card items: $e');
    }
  }


Widget buildCard(CardItem currentCardItem, BuildContext context, {required bool showFront}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),  // rounded corner radius
      side: BorderSide(
        color: showFront ? Colors.black : Colors.grey,
        width: 2.0,
      ),
    ),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Center(
        child: Text(
          showFront ? currentCardItem.front : currentCardItem.back,
          style: TextStyle(fontSize: 32),  // increase the font size here
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}




Widget build(BuildContext context) {
  if (errorOccurred) {
    // if error message was 405
    if (errorMessage == "No More Items") {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.collection.collectionName} - Play'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, size: 100), // Show an empty hourglass icon
              Text("No more items to study right now"),
            ],
          ),
        )
      );
    }  else {
      // else 
      return Text(errorMessage);
    }
  }

  if (cardItems.isEmpty) {
    // return the loading button from loading.dart
    return const Loading();
  }

  CardItem currentCardItem = cardItems.first; // Always show the first card item

  return Scaffold(
    appBar: AppBar(
        title: Text('${widget.collection.collectionName} - Play'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text('Front', style: TextStyle(color: const Color.fromARGB(255, 191, 139, 121),)),
                Listener(
                  onPointerUp: (_) {
                    sliderFocusNode.unfocus();
                  },
                  child: Slider(
                    focusNode: sliderFocusNode,
                    activeColor: Colors.brown,
                    inactiveColor: Colors.brown,
                    value: 1 - frontStartChance,
                    onChanged: (newValue) {
                      setState(() {
                        frontStartChance = 1 - newValue;
                      });
                    },
                  ),
                ),
                Text('Back', style: TextStyle(color: const Color.fromARGB(255, 191, 139, 121),)),
              ],
            ),
          ),
        ],
      ),
    body: FocusScope(
      node: FocusScopeNode(),
      autofocus: true,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                event.logicalKey == LogicalKeyboardKey.arrowDown) {
              setState(() {
                showFront = !showFront;
              });
            } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) { 
              // handle right arrow key
              _rightController.forward();
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              // handle left arrow key
              _leftController.forward();
            }
          }
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              showFront = !showFront;
            });
            _logger.info('Card tap detected. Show front: $showFront');
          },
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.velocity.pixelsPerSecond.dx > 0) {
              _rightController.forward();
            } else if (details.velocity.pixelsPerSecond.dx < 0) {
              _leftController.forward();
            }
          },
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                if (cardItems.length > 1)
                  buildCard(cardItems[1], context, showFront: nextShowFront),  // The next card
                SlideTransition(
                  position: _rightAnimation,
                  child: SlideTransition(
                    position: _leftAnimation,
                    child: buildCard(currentCardItem, context, showFront: showFront),  // The current card
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}

