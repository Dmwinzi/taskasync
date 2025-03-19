import 'package:stacked/stacked.dart';
import 'package:task_async/DI/Locator.dart';

import '../../Domain/Entities/Taskentity.dart';
import '../../Domain/Usecases/Taskusecase.dart';


class Taskviewmodel extends BaseViewModel{

  // wrote test for this viewmodel

  final Taskusecase taskusecase;

  Taskviewmodel(this.taskusecase);

  List<Taskentity> _tasks = [];
  List<Taskentity> get tasks => _tasks;

  Future<void> fetchTasks() async {
    setBusy(true);
    _tasks = await taskusecase.gettasks();
    setBusy(false);
    notifyListeners();
  }

  Future<void> addTask(Taskentity newTask) async {
    setBusy(true);
    try {
      if (_tasks.any((task) => task.title == newTask.title)) {
        throw Exception("Task already exists");
      }
      final task = await taskusecase.addtask(newTask);
      _tasks.add(task);
      notifyListeners();
    } catch (e) {
      setError(e);
    } finally {
      setBusy(false);
    }
  }


  Future<void> updateTask(Taskentity updatedTask) async {
    setBusy(true);
    final task = await taskusecase.updatetask(updatedTask);
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
    setBusy(false);
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    setBusy(true);
    await  taskusecase.deletetask(id);
    _tasks.removeWhere((task) => task.id == id);
    setBusy(false);
    notifyListeners();
  }


}