import 'package:flutter/material.dart';

void main() {
  runApp(SaveMateApp());
}

class SaveMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SaveMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, 
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('SaveMate'),
        ),
        body: Center(
          child: Text(
            'Welcome to SaveMate!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
