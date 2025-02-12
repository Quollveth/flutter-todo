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
  void addNewTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void moveTask(int from, int to) {
    var temp = tasks[from];
    tasks.removeAt(from);
    tasks.insert(to, temp);

    notifyListeners();
  }

  void toggleTaskView(int index) {
    tasks[index].expanded = !tasks[index].expanded;
    notifyListeners();
  }

  var currentScreen = Screen.list;
  void setSreen(Screen newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
