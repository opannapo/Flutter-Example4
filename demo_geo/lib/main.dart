import 'package:demo_geo/views/Splash.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.white,
          backgroundColor: Colors.white,
          canvasColor: Colors.transparent),
      home: new Splash(),
    );
  }
}
