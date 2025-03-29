import 'package:flutter/material.dart';
import 'package:testapi/ess/models/tache.dart';
import 'package:testapi/ess/services/tache_service.dart';

class DetailsTacheScreen extends StatelessWidget {
  final Tache tache;
  final TacheService _tacheService = TacheService();

  DetailsTacheScreen({super.key, required this.tache});

  // Supprimer la tâche
  void _deleteTache(BuildContext context) async {
    await _tacheService.deleteTache(tache.id);
    Navigator.pop(context); // Retour à l'écran précédent
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche supprimée avec succès')),
    );
  }

  // Marquer la tâche comme "Fait"
  void _markAsDone(BuildContext context) async {
    await _tacheService.updateTacheStatus(tache.id, true);
    Navigator.pop(context); // Retour à l'écran précédent
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tâche marquée comme faite')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Tâche'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Titre : ${tache.title}', 
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Contenu : ${tache.content}', 
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Date : ${_formatDate(tache.date as DateTime?)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),

            const Spacer(), // Pour pousser les boutons en bas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _deleteTache(context),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _markAsDone(context),
                  icon: const Icon(Icons.check, color: Colors.green),
                  label: const Text('Fait'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fonction utilitaire pour formater la date en JJ/MM/AAAA
  String _formatDate(DateTime? date) {
    if (date == null) return 'Date non définie';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
