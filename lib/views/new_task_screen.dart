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
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => appState.setSreen(Screen.list),
                    icon: Icon(Icons.close, color: theme.iconTheme.color),
                  ),
                  ElevatedButton.icon(
                    onPressed: addNew,
                    icon: Icon(Icons.send),
                    label: Text('Save'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              // Task Title
              TextField(
                controller: taskNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              // Task Description
              TextField(
                controller: taskDescController,
                keyboardType: TextInputType.multiline,
                minLines: 4,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              // Subtasks
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtasks'),
                        if (subtaskControllers.length < 10)
                          ElevatedButton(
                            onPressed: addSubtask,
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(20, 30),
                            ),
                            child: Icon(Icons.add),
                          ),
                        //endif
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (subtaskControllers.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: subtaskControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: subtaskInputs[index],
                                  ),
                                  IconButton(
                                    onPressed: () => removeSubtask(index),
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addSubtask() {
    setState(() {
      var tempController = TextEditingController();
      var tempInput = TextField(
        controller: tempController,
        decoration: InputDecoration(
          hintText: 'Subtask',
          border: OutlineInputBorder(),
        ),
      );

      subtaskInputs.add(tempInput);
      subtaskControllers.add(tempController);
    });
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
}
