import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapi/ess/models/tache.dart';
import 'package:testapi/ess/services/tache_service.dart';

class DetailsTacheScreen extends StatelessWidget {
  final Tache tache;
  final TacheService _tacheService = TacheService();

  DetailsTacheScreen({super.key, required this.tache});

  // Supprimer la tâche


Future<void> deleteTache(String id) async {
  await FirebaseFirestore.instance.collection('taches').doc(id).delete();
}

void _deleteTache(BuildContext context, String id) async {
  try {
    print("Suppression de la tâche avec ID: ${tache.id}"); // Debug
    await _tacheService.deleteTache(tache.id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tâche supprimée avec succès")),
    );
    Navigator.pop(context);
  } catch (e) {
    print("Erreur de suppression: $e"); // Debug
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors de la suppression : $e")),
    );
  }
}




// Marquer la tâche comme "Fait"
void _markAsDone(BuildContext context) async {
  await _tacheService.updateTacheStatus(tache.id, true);
  Navigator.pop(context, true); // Retourne 'true' pour signaler une action réussie
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
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Titre : ${tache.title}', 
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Text('Contenu : ${tache.content}', 
          style: const TextStyle(fontSize: 25)),
      const SizedBox(height: 10),
      Text('Date : ${_formatDate(DateTime.tryParse(tache.date))}',
          style: const TextStyle(fontSize: 20, color: Colors.grey)),

      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          ElevatedButton(
  onPressed: () => _deleteTache(context, tache.id),

  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
  ),
  child: const Text("Supprimer"),
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
)

    );
  }

  // Fonction utilitaire pour formater la date en JJ/MM/AAAA
  String _formatDate(dynamic date) {
  if (date is String) {
    date = DateTime.tryParse(date); // Convertit la chaîne en DateTime
  }
  
  if (date == null) return 'Date invalide';

  const joursSemaine = [
    'Dimanche',
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
  ];

  const moisAnnee = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  String jourSemaine = joursSemaine[date.weekday == 7 ? 0 : date.weekday];
  String mois = moisAnnee[date.month - 1];

  return '$jourSemaine ${date.day} $mois ${date.year}';
}

}
