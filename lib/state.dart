import 'package:flutter/material.dart';

enum Screen { list, create }

class AppState extends ChangeNotifier {
  var tasks = <String>[];
  void addNew(String task) {
    tasks.add(task);
    notifyListeners();
  }

  var currentScreen = Screen.list;
  void setSreen(Screen newScreen) {
    currentScreen = newScreen;
    notifyListeners();
  }
}
