import 'package:task_async/DI/Locator.dart';

import '../Entities/Taskentity.dart';
import '../Repository/Taskrepository.dart';

class Taskusecase{

  final Taskrepository repository;

  Taskusecase(this.repository);

  Future<List<Taskentity>> gettasks() async{
    return await repository.gettasks();
  }

  Future<Taskentity> addtask(Taskentity newtask) async{
     return await repository.addtask(newtask);
  }

  Future<Taskentity> updatetask(Taskentity updatedtask) async{
     return await repository.updatetask(updatedtask);
  }

  Future<String> deletetask(int id) async{
     return await repository.deletetask(id);
  }


}