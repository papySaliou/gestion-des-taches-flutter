import 'package:flutter/material.dart';
import 'package:testapi/model/tasks.dart';


class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Priority _selectedPriority;
  late TextEditingController _colorController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _contentController = TextEditingController(text: widget.task.content);
    _selectedPriority = widget.task.priority;
    _colorController = TextEditingController(text: widget.task.color);
  }

  void _submitForm() {
    widget.task.title = _titleController.text;
    widget.task.content = _contentController.text;
    widget.task.priority = _selectedPriority;
    widget.task.color = _colorController.text;

    print('Tâche modifiée: ${widget.task.title}, ${widget.task.priority}');
    Navigator.pop(context, widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Contenu'),
            ),
            DropdownButtonFormField<Priority>(
              value: _selectedPriority,
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedPriority = value!),
              decoration: const InputDecoration(labelText: 'Priorité'),
            ),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(labelText: 'Couleur'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Modifier la tâche'),
            ),
          ],
        ),
      ),
    );
  }
}
