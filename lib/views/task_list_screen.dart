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
    appState.load();

    return TaskList();
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    removeTask(int index) {
      appState.removeTask(index);
      String removed = appState.lastDeleted!.name;

      final undoToast = SnackBar(
        content: Text('Task $removed removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            appState.undoTaskDelete();
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(undoToast);
    }

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
                      borderRadius: BorderRadius.circular(8),
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
                        onDelete: () => {removeTask(index)},
                        onSubtaskCompleted: (subtask) {
                          appState.finishSubtask(index, subtask);
                        },
                        onCollapse: () => appState.toggleTaskView(index),
                      );
                    }
                    return GestureDetector(
                      key: Key('$index'),
                      onTap: () => appState.toggleTaskView(index),
                      child: TaskItemCollapsed(
                        task: appState.tasks[index],
                        onDelete: () => {removeTask(index)},
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text(
                  'You haven\'t created any tasks',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => appState.setSreen(Screen.create),
        label: const Text('Add New'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class TaskItemCollapsed extends StatelessWidget {
  const TaskItemCollapsed({
    super.key,
    required this.task,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              task.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItemExpanded extends StatelessWidget {
  const TaskItemExpanded({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onSubtaskCompleted,
    required this.onCollapse,
  });

  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onCollapse;
  final ValueSetter onSubtaskCompleted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title/buttons
            GestureDetector(
              onTap: onCollapse,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // description
            Text(
              task.description,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            // subtasks
            const SizedBox(height: 10),
            if (task.subtasks.isNotEmpty || task.completedSubtasks.isNotEmpty)
              const Text(
                "Subtasks:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            const SizedBox(height: 6),
            if (task.subtasks.isNotEmpty) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: task.subtasks.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () => onSubtaskCompleted(index),
                          icon: Icon(
                            Icons.radio_button_off,
                            color: Colors.grey,
                          ),
                        ),
                        Text(task.subtasks[index]),
                      ],
                    );
                  },
                ),
              ),
            ],
            // completed subtasks
            if (task.completedSubtasks.isNotEmpty) ...[
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: task.completedSubtasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.radio_button_checked,
                          color: Colors.grey),
                      title: Text(task.completedSubtasks[index]),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
