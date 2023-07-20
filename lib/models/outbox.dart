class Outbox {
  Map<int, int> _items = {};

  void addScore(int itemId, int increment) {
    _items.update(itemId, (existingValue) => existingValue + increment, ifAbsent: () => increment);
  }

  Map<int, int> flush() {
    var copy = Map<int, int>.from(_items);
    _items.clear();
    return copy;
  }
}
