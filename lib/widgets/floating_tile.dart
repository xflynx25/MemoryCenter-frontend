import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/loading.dart';
import 'package:logging/logging.dart';

class FloatingTitle extends StatefulWidget {
  @override
  _FloatingTitleState createState() => _FloatingTitleState();
}

class _FloatingTitleState extends State<FloatingTitle> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  final random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 5.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 5.0, end: -5.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value + sin(_controller.value * 2 * pi) * 5),
          child: child,
        );
      },
      child: Text(
        'Memory Center',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'YourFontFamily', // Replace with your font family
          fontSize: 48,
          color: Colors.yellow,
          shadows: [
            Shadow(
              offset: Offset(1.0, 1.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
