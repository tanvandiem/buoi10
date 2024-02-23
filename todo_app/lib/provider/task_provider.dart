import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/task.dart';

class TaskProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  final List<Task> _tasks = [];

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    List<String>? taskList = _prefs.getStringList('tasks');
    if (taskList != null) {
      _tasks.addAll(taskList.map((taskJson) => Task.fromJson(jsonDecode(taskJson))));
    }
    notifyListeners();
  }

  List<Task> get tasks => _tasks;

  void _saveTasks() {
    List<String> taskListJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    _prefs.setStringList('tasks', taskListJson);
  }

  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void updateTask(Task editedTask) {
    int index = _tasks.indexWhere((task) => task.id == editedTask.id);
    if (index != -1) {
      _tasks[index] = editedTask;
      _saveTasks();
      notifyListeners();
    }
  }
}

