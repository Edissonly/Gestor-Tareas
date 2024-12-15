import 'package:flutter/material.dart';
import 'task_chart.dart'; // Asegúrate de que esta importación esté bien.
import '../data/task_service.dart';

class TaskChartScreen extends StatefulWidget {
  const TaskChartScreen({super.key});

  @override
  _TaskChartScreenState createState() => _TaskChartScreenState();
}

class _TaskChartScreenState extends State<TaskChartScreen> {
  final TaskService taskService = TaskService();
  late Future<List<dynamic>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = taskService.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de Tareas'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: tasksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final tasks = snapshot.data as List;

              final completedTasks = tasks
                  .where((task) => task['isCompleted'] == true)
                  .length;
              final deletedTasks =
                  tasks.where((task) => task['isDeleted'] == true).length;
              final totalTasks = tasks.length;

              return TaskChart(
                completed: completedTasks,
                deleted: deletedTasks,
                total: totalTasks,
              );
            }
          },
        ),
      ),
    );
  }
}
