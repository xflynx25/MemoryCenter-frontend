import 'package:flutter/material.dart';

void myErrorsShowError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('An error occurred: $error'),
      backgroundColor: Colors.red,
    ),
  );
}