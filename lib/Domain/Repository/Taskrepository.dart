import 'package:task_async/Domain/Entities/Taskentity.dart';

abstract class Taskrepository{

  Future<List<Taskentity>> gettasks();

  Future<Taskentity> addtask(Taskentity newtask);

  Future<Taskentity> updatetask(Taskentity updatedtask);

  Future<String> deletetask(int id);

}