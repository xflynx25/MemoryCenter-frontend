import 'package:flutter/material.dart';
import '../models/topic.dart'; // Adjust the import based on your project structure
import '../utils/config.dart';  // Adjust the import based on your project structure


Map<int, double> calculateScoreDistribution(Topic topic) {
  Map<int, int> scoreCounts = {};
  for (var item in topic.items) {
    scoreCounts[item.score] = (scoreCounts[item.score] ?? 0) + 1;
  }

  int totalItems = topic.items.length;
  return scoreCounts.map((score, count) => MapEntry(score, count / totalItems));
}

class ScoreDistributionBar extends StatelessWidget {
  final Map<int, double> distribution;

  ScoreDistributionBar({required this.distribution});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ScoreDistributionPainter(distribution),
      child: Container(height: 20),
    );
  }
}

class _ScoreDistributionPainter extends CustomPainter {
  final Map<int, double> distribution;

  _ScoreDistributionPainter(this.distribution);

  @override
  void paint(Canvas canvas, Size size) {
    double start = 0;
    distribution.forEach((score, percent) {
      final paint = Paint()
        ..color = Config.SCORE_COLORS[score] ?? Colors.grey
        ..style = PaintingStyle.fill;

      double width = percent * size.width;
      canvas.drawRect(Rect.fromLTWH(start, 0, width, size.height), paint);
      start += width;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
