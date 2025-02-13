import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_todo/state.dart';
import 'package:flutter_todo/views/new_task_screen.dart';
import 'package:flutter_todo/views/task_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    Widget page;
    switch (appState.currentScreen) {
      case Screen.list:
        page = TaskListScreen();
        break;
      case Screen.create:
        page = NewTaskScreen();
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(
            child: page,
          ),
        );
      },
    );
  }
}
