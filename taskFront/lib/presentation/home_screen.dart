import 'package:flutter/material.dart';
import 'package:task/presentation/AddTaskScreen.dart';
import '../data/task_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'TaskChartScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService taskService = TaskService();
  late Future<List<dynamic>> tasksFuture;
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    tasksFuture = taskService.fetchTasks();
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:7001/taskHub'),
    );

    // Escuchar a backend
    _channel.stream.listen((message) {
      print("Mensaje recibido del servidor: $message");
      refreshTasks();
    });
  }

  @override
  void dispose() {
    _channel.sink.close(); // Cerrar la conexión
    super.dispose();
  }

  void refreshTasks() {
    setState(() {
      tasksFuture = taskService.fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GESTOR DE TAREAS'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Lista de tareas
          Flexible(
            flex: 3,
            child: FutureBuilder(
              future: tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final tasks = snapshot.data as List;
                  print("Tasks data: $tasks"); //imprimir las tareas
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                    
                      bool isDeleted = task['isDeleted'] == true;

                      return ListTile(
                        tileColor: isDeleted ? Colors.red.shade100 : null, 
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            color: isDeleted ? Colors.red : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          'Completada: ${task['isCompleted'] ? 'Sí' : 'No'}',
                          style: TextStyle(
                            color: isDeleted ? Colors.red : Colors.black,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () async {
                                await taskService.completeTask(task['id']);
                                refreshTasks();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await taskService.deleteTask(task['id']);
                                refreshTasks();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((_) => refreshTasks());
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      // Agregar un botón para navegar al gráfico de tareas
      bottomNavigationBar: BottomAppBar(
        child: IconButton(
          icon: const Icon(Icons.pie_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TaskChartScreen()),
            );
          },
        ),
      ),
    );
  }
}
