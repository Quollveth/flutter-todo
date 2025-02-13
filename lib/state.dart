import 'package:flutter/material.dart';

enum Screen { list, create }

class Task {
  String name;
  String description = '';

  var completedSubtasks = <String>[];
  var subtasks = <String>[];

  bool expanded = false;

  Task(this.name);
}

class AppState extends ChangeNotifier {
  // Task list
  var tasks = <Task>[];
  Task? lastDeleted;

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

  // global
  void _save() {
    //TODO: learn to save lmao
    notifyListeners();
  }
}
