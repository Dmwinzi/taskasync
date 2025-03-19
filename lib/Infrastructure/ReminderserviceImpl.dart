import 'package:flutter/services.dart';
import 'package:task_async/Domain/Services/Reminderservice.dart';

class ReminderserviceImpl implements Reminderservice{

  static const MethodChannel _channel = MethodChannel('task_reminder');

  @override
  Future<void> scheduleReminder(int id, String title, String dueDate) async{
    try {
      await _channel.invokeMethod('schedulereminder', {
        'id': id,
        'title': title,
        'dueDate': dueDate,
      });
    } catch (e) {
      throw Exception("Failed to schedule reminder: $e");
    }
  }



}