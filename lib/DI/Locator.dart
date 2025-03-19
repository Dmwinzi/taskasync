import 'package:get_it/get_it.dart';
import 'package:task_async/Data/RemoteDataSource/RepoImpl/TaskrepoImpl.dart';
import 'package:task_async/Domain/Services/Reminderservice.dart';
import 'package:task_async/Domain/Usecases/Reminderserviceusecase.dart';
import 'package:task_async/Domain/Usecases/Taskusecase.dart';
import 'package:task_async/Infrastructure/ReminderserviceImpl.dart';

import '../Domain/Repository/Taskrepository.dart';
import '../Presentation/Viewmodel/Reminderviewmodel.dart';
import '../Presentation/Viewmodel/Taskviewmodel.dart';

var locator = GetIt.instance;

Future<void> Setup() async{

  locator.registerLazySingleton<Taskrepository>(() => TaskRepositoryImpl());
  locator.registerLazySingleton<Taskusecase>(() => Taskusecase(locator<Taskrepository>()));
  locator.registerLazySingleton(() => Taskviewmodel(locator<Taskusecase>()));
  locator.registerLazySingleton<Reminderservice>(() => ReminderserviceImpl());
  locator.registerLazySingleton(() => Reminderserviceusecase(locator<Reminderservice>()));
  locator.registerLazySingleton(() => Reminderviewmodel(locator<Reminderserviceusecase>()));


}