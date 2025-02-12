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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (appState.tasks.isNotEmpty)
              Expanded(
                child: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) {
                    appState.moveTask(oldIndex, newIndex);
                  },
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      elevation: 4,
                      child: child,
                    );
                  },
                  physics: const BouncingScrollPhysics(),
                  itemCount: appState.tasks.length,
                  itemBuilder: (context, index) {
                    if (appState.tasks[index].expanded) {
                      return TaskItemExpanded(
                        key: Key('$index'),
                        task: appState.tasks[index],
                        onDelete: () => print('placeholder'),
                      );
                    }
                    return TaskItem(
                      key: Key('$index'),
                      task: appState.tasks[index],
                      onExpand: () => appState.toggleTaskView(index),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text(
                  'No tasks available',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {appState.setSreen(Screen.create)},
        label: const Text('Add New'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onExpand,
  });

  final Task task;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        task.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        onPressed: onExpand,
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}

class TaskItemExpanded extends StatelessWidget {
  const TaskItemExpanded({
    super.key,
    required this.task,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        task.name,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        onPressed: onDelete,
        icon: const Icon(
          Icons.delete_forever,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}
