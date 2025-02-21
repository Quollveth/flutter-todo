import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_todo/lib/tasklist.pb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

enum Screen { list, create }

class Task {
  String name;
  String description = '';

  var completedSubtasks = <String>[];
  var subtasks = <String>[];

  bool expanded = false;

  Task(this.name);

  TaskItem toItem() {
    return TaskItem(
      name: name,
      description: description,
      completedSubtasks: completedSubtasks,
      subtasks: subtasks,
    );
  }

  static Task fromItem(TaskItem item) {
    final tmp = Task(item.name);
    tmp.description = item.description;
    tmp.completedSubtasks = List.from(item.completedSubtasks);
    tmp.subtasks = List.from(item.subtasks);

    return tmp;
  }
}

class AppState extends ChangeNotifier {
  var tasks = <Task>[];
  Task? lastDeleted;
  bool initialized = false;

  Future<String> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _taskfile async {
    final path = await _localDir;
    return File('$path/tasklist.pb');
  }

  // global
  void _save() async {
    TaskList taskList;
    try {
      final file = await _taskfile;
      taskList = TaskList();

      tasks.forEach((t) {
        taskList.tasks.add(t.toItem());
      });

      file.writeAsBytes(taskList.writeToBuffer());
    } catch (e) {
      //TODO: handle error
      debugPrint('Error saving tasks: $e');
    }
  }

  Future<List<Task>> load() async {
    print("loading taskfile");
    try {
      final file = await _taskfile;
      if (!file.existsSync()) {
        print("taskfile does not exist");
        return [];
      }

      TaskList tasklist = TaskList.fromBuffer(file.readAsBytesSync());
      print("loaded taskfile");
      print(tasklist.tasks[0].name);
      return tasklist.tasks.map((t) => Task.fromItem(t)).toList();
    } catch (e) {
      //TODO: handle error
      debugPrint('Error loading tasks: $e');
      return Future.error(e);
    }
  }

  void initialize(List<Task>? data) {
    print("initialized");
    if (data == null) {
      initialized = true;
      notifyListeners();
      return;
    }
    tasks = List.from(data);
    initialized = true;
    notifyListeners();
  }

  // Task list
  void addNewTask(Task task) {
    tasks.add(task);
    _save();
  }

  void removeTask(int index) {
    lastDeleted = tasks.removeAt(index);
    _save();
  }

  void undoTaskDelete() {
    if (lastDeleted == null) return;
    tasks.add(lastDeleted!);
    _save();
  }

  void moveTask(int from, int to) {
    var temp = tasks[from];
    tasks.removeAt(from);
    tasks.insert(to, temp);

    _save();
  }

  void toggleTaskView(int index) {
    tasks[index].expanded = !tasks[index].expanded;
    notifyListeners();
  }

  void finishSubtask(int taskIndex, int subtask) {
    var temp = tasks[taskIndex].subtasks.removeAt(subtask);
    tasks[taskIndex].completedSubtasks.add(temp);
    _save();
  }

  // views
  var currentScreen = Screen.list;
  void setSreen(Screen newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
