import 'package:flutter/material.dart';
import 'package:flutter_todo/components/newTaskScreen.dart';
import 'package:provider/provider.dart';

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

enum Screen { list, create }

class AppState extends ChangeNotifier {
  var tasks = <String>[];
  void addNew(String task) {
    tasks.add(task);
    notifyListeners();
  }

  var currentScreen = Screen.list;
  void setSreen(Screen newScreen) {
    currentScreen = newScreen;
    notifyListeners();
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
        page = ListPage();
        break;
      case Screen.create:
        page = NewTaskScreen();
        break;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(child: page),
        );
      },
    );
  }
}

class ListPage extends StatelessWidget {
  const ListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      body: Column(
        children: [
          if (appState.tasks.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: appState.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(appState.tasks[index]),
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {appState.setSreen(Screen.create)},
        label: const Text('Add New'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
