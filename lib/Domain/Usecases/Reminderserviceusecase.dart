import 'package:task_async/Domain/Services/Reminderservice.dart';

class Reminderserviceusecase {

  final Reminderservice reminderservice;

  Reminderserviceusecase(this.reminderservice);

  Future<void> scheduleReminder(int id, String title, String dueDate){
    return reminderservice.scheduleReminder(id, title, dueDate);
  }

}