// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class AddTaskForm extends StatefulWidget {
//   final Function refreshData;

//   const AddTaskForm({super.key, required this.refreshData});

//   @override
//   _AddTaskFormState createState() => _AddTaskFormState();
// }

// class _AddTaskFormState extends State<AddTaskForm> {
//   final String apiUrl = 'http://localhost:3000/task';
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController priorityController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();

//   DateTime selectedTaskDate = DateTime.now();
//   String selectedTaskPriority = 'Moyenne';


//   Future<void> addTask() async {
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'title': titleController.text,
//           'description': descriptionController.text,
//           'priority': priorityController.text,
//           'date': dateController.text,
//         }),
//       );

//       if (response.statusCode == 201) {
//         widget.refreshData(); // Rafraîchir les données après ajout
//         Navigator.pop(context);
//       } else {
//         throw Exception('Erreur lors de l\'ajout de la tâche');
//       }
//     } catch (e) {
//       print('Erreur : $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Ajouter une tâche'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Titre')),
//           TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
//           TextField(controller: priorityController, decoration: const InputDecoration(labelText: 'Priorité')),
//           TextField(controller: dateController, decoration: const InputDecoration(labelText: 'Date (JJ/MM/AAAA)')),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Annuler'),
//         ),
//         ElevatedButton(
//           onPressed: addTask,
//           child: const Text('Ajouter'),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Auth

class AddTaskForm extends StatefulWidget {
  final Function refreshData;

  const AddTaskForm({super.key, required this.refreshData});

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final String apiUrl = 'http://localhost:3000/task';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedTaskDate = DateTime.now();
  String selectedTaskPriority = 'Moyenne';
  bool _isLoading = false;

  // Fonction pour obtenir l'ID de l'utilisateur actuellement connecté
  String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTaskDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedTaskDate) {
      setState(() {
        selectedTaskDate = picked;
      });
    }
  }

  Future<void> addTask() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      _showMessage('Veuillez remplir tous les champs.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userId = getCurrentUserId();  // Récupérer l'ID de l'utilisateur connecté
      if (userId == null) {
        _showMessage('Utilisateur non connecté.');
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': titleController.text,
          'description': descriptionController.text,
          'priority': selectedTaskPriority,
          'date': selectedTaskDate.toIso8601String(),
          'userId': userId,  // Inclure l'ID utilisateur
        }),
      );

      if (response.statusCode == 201) {
        widget.refreshData();
        Navigator.pop(context);
        _showMessage('Tâche ajoutée avec succès.', isSuccess: true);
      } else {
        _showMessage('Erreur lors de l\'ajout de la tâche.');
      }
    } catch (e) {
      _showMessage('Erreur de connexion : $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une tâche'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Titre'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          DropdownButtonFormField<String>(
            value: selectedTaskPriority,
            items: const [
              DropdownMenuItem(value: 'Haute', child: Text('Haute')),
              DropdownMenuItem(value: 'Moyenne', child: Text('Moyenne')),
              DropdownMenuItem(value: 'Basse', child: Text('Basse')),
            ],
            onChanged: (value) => setState(() => selectedTaskPriority = value!),
            decoration: const InputDecoration(labelText: 'Priorité'),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: Text('Date : ${selectedTaskDate.day}/${selectedTaskDate.month}/${selectedTaskDate.year}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : addTask,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Ajouter'),
        ),
      ],
    );
  }
}
