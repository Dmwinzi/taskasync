import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Domain/Entities/Taskentity.dart';
import '../../../Domain/Repository/Taskrepository.dart';
import '../../Models/TaskModel.dart';

class TaskRepositoryImpl implements Taskrepository {
  List<Taskentity> _tasks = [];

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/tasks.json');
  }

  @override
  Future<List<Taskentity>> gettasks() async {
    if (_tasks.isNotEmpty) return _tasks;

    try {
      final file = await _getLocalFile();

      if (!await file.exists()) {
        final String response = await rootBundle.loadString('asset/mock/tasks.json');
        await file.writeAsString(response);
      }

      final String jsonString = await file.readAsString();
      final List<dynamic> data = json.decode(jsonString);
      print(data);
      _tasks = data.map((json) => TaskModel.fromJson(json)).map((taskModel) => Taskentity(
        id: taskModel.id,
        title: taskModel.title,
        priority: taskModel.priority,
        completed: taskModel.completed,
        dueDate: taskModel.dueDate,
      )).toList();

      return _tasks;
    } catch (e) {
      throw Exception('Failed to load tasks from local JSON: $e');
    }
  }

  @override
  Future<Taskentity> addtask(Taskentity newTask) async {
    try {
      final file = await _getLocalFile();
      await gettasks();

      final existingIds = _tasks.map((task) => task.id ?? 0).toSet();
      int newId = 1;

      while (existingIds.contains(newId)) {
        newId++;
      }

      newTask = newTask.copyWith(id: newId);
      _tasks.add(newTask);

      final String jsonString = json.encode(
        _tasks.map((task) => TaskModel(
          id: task.id ?? 0,
          title: task.title ?? "Untitled Task",
          priority: task.priority ?? "Low",
          completed: task.completed ?? "not started",
          dueDate: task.dueDate ?? "No Due Date",
        ).toJson()).toList(),
      );

      await file.writeAsString(jsonString);

      return newTask;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  @override
  Future<Taskentity> updatetask(Taskentity updatedTask) async {
    try {
      final file = await _getLocalFile();

      await gettasks();

      int index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index == -1) throw Exception("Task not found");

      _tasks[index] = updatedTask;

      final String jsonString = json.encode(
        _tasks.map((task) => TaskModel(
          id: task.id ?? 0,
          title: task.title ?? "Untitled Task",
          priority: task.priority ?? "Low",
          completed: task.completed ?? "not started",
          dueDate: task.dueDate ?? "No Due Date",
        ).toJson()).toList(),
      );

      await file.writeAsString(jsonString);

      return updatedTask;
    } catch (e) {
      throw Exception("Failed to update task: $e");
    }
  }

  @override
  Future<String> deletetask(int id) async {
    try {
      final file = await _getLocalFile();

      await gettasks();

      final int initialLength = _tasks.length;
      _tasks.removeWhere((task) => task.id == id);

      if (_tasks.length < initialLength) {
        final String jsonString = json.encode(
          _tasks.map((task) => TaskModel(
            id: task.id ?? 0,
            title: task.title ?? "Untitled Task",
            priority: task.priority ?? "Low",
            completed: task.completed ?? "not started",
            dueDate: task.dueDate ?? "No Due Date",
          ).toJson()).toList(),
        );

        await file.writeAsString(jsonString);

        return "Task deleted successfully";
      } else {
        throw Exception("Task not found");
      }
    } catch (e) {
      throw Exception("Failed to delete task: $e");
    }
  }


}