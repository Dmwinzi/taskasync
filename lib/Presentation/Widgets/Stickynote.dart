import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Splashscreen.dart';

class StickyNote extends StatelessWidget {
  final StickyNoteData data;

  StickyNote({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1 + data.tasks.length * 0.01),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unique Note Title
          Text(
            "ToDo's:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          ...data.tasks.map((task) {
            return Row(
              children: [
                Checkbox(
                  value: task.isChecked,
                  onChanged: null,
                ),
                Expanded(
                  child: Text(
                    task.text,
                    style: TextStyle(
                      decoration: task.isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}