import 'package:flutter/material.dart';
import 'package:testapi/model/tasks.dart';


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required void Function() refreshData});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  Priority? _selectedPriority;
  final TextEditingController _colorController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        title: _titleController.text,
        content: _contentController.text,
        priority: _selectedPriority ?? Priority.Medium,
        color: _colorController.text,
        dueDate: DateTime.now(),
      );

      print('Tâche ajoutée: ${newTask.title}, ${newTask.priority}');
      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter une tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Contenu'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                items: Priority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(priority.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedPriority = value),
                decoration: const InputDecoration(labelText: 'Priorité'),
              ),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(labelText: 'Couleur'),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Ajouter la tâche'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
