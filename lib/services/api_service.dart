import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testapi/services/task.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/task';

  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des tâches');
    }
  }
}