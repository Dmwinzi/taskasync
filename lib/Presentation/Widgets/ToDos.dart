import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:task_async/DI/Locator.dart';
import 'package:task_async/Presentation/Widgets/Taskcard.dart';
import 'package:task_async/Presentation/Widgets/updatedialogue.dart';
import '../../Utils/Permissions.dart';
import '../Viewmodel/Reminderviewmodel.dart';
import '../Viewmodel/Taskviewmodel.dart';
import 'addtaskdialogue.dart';


import 'package:stacked/stacked.dart';

class Todos extends StatelessWidget {
  final Taskviewmodel viewModel;

  const Todos({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final Set<String> taskTitles = {};
    final todoTasks = viewModel.tasks.where((task) {
      if (task.completed == "not started" && !taskTitles.contains(task.title)) {
        taskTitles.add(task.title ?? "");
        return true;
      }
      return false;
    }).toList();

    if (viewModel.isBusy) {
      return Center(child: CircularProgressIndicator());
    }

    if (todoTasks.isEmpty) {
      return Center(child: Text("No tasks available"));
    }

    return ViewModelBuilder<Reminderviewmodel>.reactive(
        viewModelBuilder: () => locator<Reminderviewmodel>(),
      disposeViewModel: false,
      builder: (context, reminderViewModel, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: todoTasks.length,
          itemBuilder: (context, index) {
            final task = todoTasks[index];
            return GestureDetector(
              onTap: () {
                print(task.dueDate);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => UpdateBottomSheet(task: task),
                );
              },
              child: TaskCrd(
                title: task.title ?? "Task",
                progress: 0.0,
                priority: task.priority ?? "Low",
                isCompleted: false,
                onDelete: () => viewModel.deleteTask(task.id!),
                onNotify: () async {
                  await requestPermissions();

                  if (task.dueDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Reminder not set. Due date is missing."),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    return;
                  }

                  var result = await reminderViewModel.scheduleReminder(
                    task.id!,
                    task.title ?? "No title",
                    task.dueDate!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result
                          ? "Reminder scheduled successfully!"
                          : "Failed to schedule reminder."),
                      backgroundColor: result ? Colors.green : Colors.red,
                    ),
                  );
                },

              ),
            );
          },
        );
      },
    );
  }


}




