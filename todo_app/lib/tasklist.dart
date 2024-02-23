import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/add_task.dart';
import 'package:todo_app/provider/task_provider.dart';
import 'package:todo_app/task.dart';

// Import màn hình AddTaskScreen

class TaskListScreen extends StatelessWidget {
  final List<Task> tasks;

  const TaskListScreen(this.tasks, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Container(
            padding: const EdgeInsets.fromLTRB(23, 18, 16, 0),
            height: 163,
            decoration: BoxDecoration(
              color: task.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 27,
                      width: 75,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color(0xff13E2C1),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(child: Text("School")),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 27,
                      width: 75,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: const Color(0xff13E2C1),
                        ),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(child: Text("Everyday")),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskScreen(task: task),
                          ),
                        ).then((editedTask) {
                          if (editedTask != null) {
                          
                            Provider.of<TaskProvider>(context, listen: false)
                                .updateTask(editedTask);
                          }
                        });
                      },
                      child: Image.asset('assets/edit.png'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  task.name ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_month_outlined),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat.yMd().format(task.time!.toLocal()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.av_timer_outlined),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat.Hm().format(task.time!.toLocal()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
