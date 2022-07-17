// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  final Widget startPoint;

  MyApp({
    Key? key,
    required this.startPoint,
  }) : super(key: key);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.startPoint,
    );
  }
}
