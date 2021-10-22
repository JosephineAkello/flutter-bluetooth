import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Color((0xFF0B0A3B))),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Flutter + Bluetooth'),
            centerTitle: true,
          ),
          body: Center(
            child: Text('Heey Bluetooth'))));
  }
}
