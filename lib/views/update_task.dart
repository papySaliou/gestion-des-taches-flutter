import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateTaskForm extends StatefulWidget {
  final String id;
  final String currentTitle;
  final String currentDescription;
  final Function refreshData;

  const UpdateTaskForm({
    super.key,
    required this.id,
    required this.currentTitle,
    required this.currentDescription,
    required this.refreshData,
  });

  @override
  _UpdateTaskFormState createState() => _UpdateTaskFormState();
}

class _UpdateTaskFormState extends State<UpdateTaskForm> {
  final String apiUrl = 'http://localhost:3000/task';
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.currentTitle);
    descriptionController = TextEditingController(text: widget.currentDescription);
  }

  Future<void> updateTask() async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${widget.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': titleController.text,
          'description': descriptionController.text,
        }),
      );

      if (response.statusCode == 200) {
        widget.refreshData(); // Rafraîchir les données après modification
        Navigator.pop(context);
      } else {
        throw Exception('Erreur lors de la modification de la tâche');
      }
    } catch (e) {
      print('Erreur : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier la tâche'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titre')),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: updateTask,
          child: const Text('Modifier'),
        ),
      ],
    );
  }
}
