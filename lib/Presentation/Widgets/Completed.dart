import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:task_async/Presentation/Widgets/updatedialogue.dart';
import '../../DI/Locator.dart';
import '../../Utils/Permissions.dart';
import '../Viewmodel/Reminderviewmodel.dart';
import '../Viewmodel/Taskviewmodel.dart';
import 'Taskcard.dart';

class Completed extends StatelessWidget {
  final Taskviewmodel viewModel;
  const Completed({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    if (viewModel.isBusy) {
      return Center(child: CircularProgressIndicator());
    }

    final Set<String> taskTitlesCompleted = {};
    final completedTasks = viewModel.tasks.where((task) {
      if (task.completed == "completed" && !taskTitlesCompleted.contains(task.title)) {
        taskTitlesCompleted.add(task.title ?? "");
        return true;
      }
      return false;
    }).toList();

    if (completedTasks.isEmpty) {
      return Center(child: Text("No completed tasks"));
    }

    return ViewModelBuilder<Reminderviewmodel>.reactive(
      viewModelBuilder: () => locator<Reminderviewmodel>(),
      disposeViewModel: false,
      builder: (context, reminderViewModel, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: completedTasks.length,
          itemBuilder: (context, index) {
            final task = completedTasks[index];
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

