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
                      return GestureDetector(
                        key: Key('$index'),
                        onTap: () => appState.toggleTaskView(index),
                        child: TaskItemExpanded(
                          task: appState.tasks[index],
                          onDelete: () => print('placeholder'),
                        ),
                      );
                    }
                    return GestureDetector(
                      key: Key('$index'),
                      onTap: () => appState.toggleTaskView(index),
                      child: TaskItem(
                        task: appState.tasks[index],
                        onDelete: () => print('placeholder'),
                      ),
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
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(task.name),
        IconButton(onPressed: onDelete, icon: Icon(Icons.delete))
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(task.name),
            IconButton(onPressed: onDelete, icon: Icon(Icons.delete))
          ],
        ),
        Text(task.description),
        if (task.subtasks.isNotEmpty)
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100),
            child: ListView.builder(
              itemCount: task.subtasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(task.subtasks[index]),
                  trailing: Icon(Icons.radio_button_off),
                );
              },
            ),
          ),
      ],
    );
  }
}
