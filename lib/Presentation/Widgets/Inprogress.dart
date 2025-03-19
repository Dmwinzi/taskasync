import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:task_async/Presentation/Widgets/updatedialogue.dart';
import '../../DI/Locator.dart';
import '../../Utils/Permissions.dart';
import '../Viewmodel/Reminderviewmodel.dart';
import '../Viewmodel/Taskviewmodel.dart';
import 'Taskcard.dart';

class Inprogress extends StatelessWidget {
  final Taskviewmodel viewModel;
  const Inprogress({required this.viewModel, super.key});

  @override
  Widget build(BuildContext context) {
    final Set<String> taskTitlesInProgress = {};
    final inProgressTasks = viewModel.tasks.where((task) {
      if (task.completed == "inprogress" && !taskTitlesInProgress.contains(task.title)) {
        taskTitlesInProgress.add(task.title ?? "");
        return true;
      }
      return false;
    }).toList();

    if (viewModel.isBusy) {
      return Center(child: CircularProgressIndicator());
    }

    if (inProgressTasks.isEmpty) {
      return Center(child: Text("No tasks in progress"));
    }
    return ViewModelBuilder<Reminderviewmodel>.reactive(
      viewModelBuilder: () => locator<Reminderviewmodel>(),
      disposeViewModel: false,
      builder: (context, reminderViewModel, child) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: inProgressTasks.length,
          itemBuilder: (context, index) {
            final task = inProgressTasks[index];
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

