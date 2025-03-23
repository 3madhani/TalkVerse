import 'package:flutter/material.dart';

class ChitChat extends StatelessWidget {
  const ChitChat({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.dark,
        ),
      ),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.lightBlueAccent,
          brightness: Brightness.light,
        ),
      ),
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {}),
        appBar: AppBar(title: const Text('ChitChat')),
        body: const Center(
          child: Card(
            child: Padding(padding: EdgeInsets.all(20), child: CircleAvatar()),
          ),
        ),
      ),
    );
  }
}
