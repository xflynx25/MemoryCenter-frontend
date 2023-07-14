import 'package:flutter/material.dart';

class CustomWillPopScope extends StatelessWidget {
  final Function onWillPop;
  final Widget child;

  CustomWillPopScope({required this.onWillPop, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onWillPop();
        return true;
      },
      child: child,
    );
  }
}
