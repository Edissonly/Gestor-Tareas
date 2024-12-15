import 'package:flutter/material.dart';
import '../data/task_service.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TaskService taskService = TaskService();

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Tarea'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nombre de la Tarea'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty) {
                  await taskService.createTask(_titleController.text, false);
                  Navigator.pop(context); // Vuelve a la pantalla principal
                }
              },
              child: const Text('Agregar Tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
