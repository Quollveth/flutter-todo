import 'package:flutter/material.dart';
import 'package:flutter_todo/state.dart';
import 'package:provider/provider.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final taskNameController = TextEditingController();
  final taskDescController = TextEditingController();

  late AppState appState;

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescController.dispose();

    for (var i = 0; i < subtaskControllers.length; i++) {
      subtaskControllers[i].dispose();
    }
    super.dispose();
  }

  var subtaskControllers = <TextEditingController>[];
  var subtaskInputs = <TextField>[];

  @override
  Widget build(BuildContext context) {
    appState = context.watch<AppState>();
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => appState.setSreen(Screen.list),
                icon: Icon(Icons.close, color: theme.iconTheme.color),
              ),
              ElevatedButton(
                onPressed: addNew,
                child: Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Task title
          TextField(
            controller: taskNameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Add title',
            ),
          ),
          // Task Description
          TextField(
            controller: taskDescController,
            keyboardType: TextInputType.multiline,
            minLines: 6,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Description (optional)',
            ),
          ),
          // Subtasks
          Center(
            child: Column(
              children: [
                Text('Subtasks'),
                if (subtaskControllers.isNotEmpty)
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: subtaskControllers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: subtaskInputs[index],
                          trailing: IconButton(
                            onPressed: () => removeSubtask(index),
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                  ),
                if (subtaskControllers.length < 3)
                  ElevatedButton(
                    onPressed: addSubtask,
                    child: Text('Add subtask'),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void addNew() {
    Task temp = Task(taskNameController.text);
    temp.description = taskDescController.text;

    for (var i = 0; i < subtaskControllers.length; i++) {
      temp.subtasks.add(subtaskControllers[i].text);
    }

    appState.addNewTask(temp);

    FocusManager.instance.primaryFocus?.unfocus();
    taskNameController.clear();
    appState.setSreen(Screen.list); // close screen
  }

  void removeSubtask(int index) {
    setState(() {
      subtaskControllers.removeAt(index);
      subtaskInputs.removeAt(index);
    });
  }

  void addSubtask() {
    setState(() {
      var tempController = TextEditingController();
      var tempInput = TextField(
        controller: tempController,
        decoration: InputDecoration(hintText: 'Subtask'),
      );

      subtaskControllers.add(tempController);
      subtaskInputs.add(tempInput);
    });
  }
}
