import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // int taskCount = 0;
  // keeping taskCount as a global variable is a bad idea,
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ParentWidget());
  }
}

class ParentWidget extends StatefulWidget {
  @override
  _ParentWidgetState createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  int taskCount = 0;

  void addTask() {
    setState(() {
      taskCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My task")),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TaskDisplay(taskCount: taskCount),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(onPressed: addTask, child: Text("Add task"))
      ]),
    );
  }
}

class TaskDisplay extends StatelessWidget {
  final int taskCount;
  const TaskDisplay({required this.taskCount});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Task: $taskCount",
      style: TextStyle(fontSize: 24),
    );
  }
}
