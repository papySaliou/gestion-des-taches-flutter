import 'package:flutter/material.dart';
import 'package:testapi/ess/models/tache.dart';
import 'package:testapi/ess/services/tache_service.dart';

class EditTacheScreen extends StatefulWidget {
  final Tache tache;

  const EditTacheScreen({super.key, required this.tache});

  @override
  State<EditTacheScreen> createState() => _EditTacheScreenState();
}

class _EditTacheScreenState extends State<EditTacheScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  DateTime selectedTaskDate = DateTime.now();
  String? selectedTaskPriority ;
  // final _dateController = TextEditingController();

  final TacheService _tacheService = TacheService();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.tache.title;
    _contentController.text = widget.tache.content;
  }

  void _editTache() {
    final updatedTache = Tache(
      id: widget.tache.id,
      title: _titleController.text,
      content: _contentController.text,
      date: widget.tache.date,
      priority: widget.tache.priority,
      uid: widget.tache.uid,
    );
    _tacheService.updateTache(updatedTache);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifier la tâche')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Titre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Contenu'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _editTache,
              child: const Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
