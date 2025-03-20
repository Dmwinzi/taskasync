import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../DI/Locator.dart';
import '../../Domain/Entities/Taskentity.dart';
import '../Viewmodel/Taskviewmodel.dart';

class UpdateBottomSheet extends StatefulWidget {

  final Taskentity task;

  UpdateBottomSheet({required this.task});

  @override
  _UpdateBottomSheetState createState() => _UpdateBottomSheetState();
}

class _UpdateBottomSheetState extends State<UpdateBottomSheet> {
  String selectedPriority = "";
  String? selectedTaskStatus;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController titlecontroller = TextEditingController();


  void selectPriority(String priority) {
    setState(() {
      selectedPriority = priority;
    });
  }


  Future<void> pickDate(BuildContext context, bool isStartDate) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<Taskviewmodel>.reactive(
      disposeViewModel: false,
      viewModelBuilder: () => locator<Taskviewmodel>(),
      onViewModelReady: (model) => model.fetchTasks(),
      builder: (context, model, child) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text("Title", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                TextField(
                  controller: titlecontroller,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: "Enter task name",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                Text("Priority", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedTaskStatus,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[900],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  hint: Text("Select Task Status", style: TextStyle(color: Colors.grey)),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTaskStatus = newValue;
                    });
                  },
                  items: ["Not Started", "In Progress", "Completed"].map((status) {
                    Color color = status == "Not Started" ? Colors.red :
                    (status == "In Progress" ? Colors.orange : Colors.green);
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status, style: TextStyle(color: color)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Starting Date", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => pickDate(context, true),
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  hintText: startDate == null ? "Select start date" : startDate!.toLocal().toString().split(' ')[0],
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ending Date", style: TextStyle(color: Colors.white)),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () => pickDate(context, false),
                            child: AbsorbPointer(
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[900],
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  hintText: endDate == null ? "Select end date" : endDate!.toLocal().toString().split(' ')[0],
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text("Task Priority", style: TextStyle(color: Colors.white)),
                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => selectPriority("High"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPriority == "High" ? Colors.red : Colors.black,
                          side: BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("High", style: TextStyle(color: selectedPriority == "High" ? Colors.black : Colors.red)),
                            SizedBox(width: 4),
                            Icon(
                              selectedPriority == "High" ? Icons.check_box : Icons.check_box_outline_blank,
                              color: selectedPriority == "High" ? Colors.black : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => selectPriority("Medium"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPriority == "Medium" ? Colors.orange : Colors.black,
                          side: BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Medium", style: TextStyle(color: selectedPriority == "Medium" ? Colors.black : Colors.orange)),
                            SizedBox(width: 4),
                            Icon(
                              selectedPriority == "Medium" ? Icons.check_box : Icons.check_box_outline_blank,
                              color: selectedPriority == "Medium" ? Colors.black : Colors.orange,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => selectPriority("Low"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPriority == "Low" ? Colors.green : Colors.black,
                          side: BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Low", style: TextStyle(color: selectedPriority == "Low" ? Colors.black : Colors.green)),
                            SizedBox(width: 4),
                            Icon(
                              selectedPriority == "Low" ? Icons.check_box : Icons.check_box_outline_blank,
                              color: selectedPriority == "Low" ? Colors.black : Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: model.isBusy
                            ? null
                            : () async {
                          if (titlecontroller.text.isEmpty || selectedPriority.isEmpty || selectedTaskStatus == null || startDate == null) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill in all fields"),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }

                          var statusMap = {
                            "Not Started": "not started",
                            "In Progress": "inprogress",
                            "Completed": "completed"
                          };

                          var status = statusMap[selectedTaskStatus] ?? "completed";

                          Taskentity task  = Taskentity(
                            id: widget.task.id,
                            title: titlecontroller.text,
                            priority: selectedPriority,
                            completed: status ,
                            dueDate: endDate?.toIso8601String(),
                          );

                          await model.updateTask(task);

                          if (!model.hasError) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Failed to update task"),
                              backgroundColor: Colors.red,
                            ));
                          }
                        },
                        child: model.isBusy
                            ? CircularProgressIndicator(color: Colors.black)
                            : Text("Update", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
