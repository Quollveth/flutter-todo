import 'package:flutter/material.dart';
import 'package:flutter_todo/state.dart';
import 'package:provider/provider.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({
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
