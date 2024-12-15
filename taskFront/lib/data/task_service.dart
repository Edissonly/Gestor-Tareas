import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  //final String baseUrl = 'http://10.0.2.2:5000/api/Tasks';
  final String baseUrl = 'http://10.0.2.2:7001/api/tasks';

  Future<List<dynamic>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createTask(String title, [bool isCompleted = false]) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'isCompleted': false,
        'isDeleted': false,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> completeTask(int taskId) async {
    final url = Uri.parse('$baseUrl/$taskId/complete');
    final response = await http.put(url);
    if (response.statusCode != 204) {
      throw Exception('Failed to complete task');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final url = Uri.parse('$baseUrl/$taskId');
    final response = await http.delete(url);
    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}
