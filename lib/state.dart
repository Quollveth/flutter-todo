import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
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
  Task.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        description = json['description'] as String? ?? '',
        completedSubtasks = List<String>.from(json['completedSubtasks'] ?? []),
        subtasks = List<String>.from(json['subtasks'] ?? []);

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'completedSubtasks': completedSubtasks,
        'subtasks': subtasks,
      };
}

class AppState extends ChangeNotifier {
  var tasks = <Task>[];
  Task? lastDeleted;
  Future<String> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _taskfile async {
    final path = await _localDir;
    return File('$path/tasklist.json');
  }

  // global
  void _save() async {
    try {
      final file = await _taskfile;
      final jsonString =
          jsonEncode(tasks.map((task) => task.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      //TODO: handle error
      debugPrint('Error saving tasks: $e');
    }
    notifyListeners();
  }

  void load() async {
    try {
      final file = await _taskfile;
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        tasks = jsonList.map((json) => Task.fromJson(json)).toList();
      }
    } catch (e) {
      //TODO: handle error
      debugPrint('Error loading tasks: $e');
    }
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
