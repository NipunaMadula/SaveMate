import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';

void main() {
  runApp(SaveMateApp());
}

class SaveMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
