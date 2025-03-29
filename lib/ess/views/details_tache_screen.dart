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
  Navigator.pop(context, true); // Retourne 'true' pour signaler une action réussie
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Tâche supprimée avec succès')),
  );
}

// Marquer la tâche comme "Fait"
void _markAsDone(BuildContext context) async {
  await _tacheService.updateTacheStatus(tache.id, true);
  Navigator.pop(context, true); // Retourne 'true' pour signaler une action réussie
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Tâche marquée comme faite')),
  );
}

  // // Supprimer la tâche
  // void _deleteTache(BuildContext context) async {
  //   await _tacheService.deleteTache(tache.id);
  //   Navigator.pop(context); // Retour à l'écran précédent
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Tâche supprimée avec succès')),
  //   );
  // }

  // // Marquer la tâche comme "Fait"
  // void _markAsDone(BuildContext context) async {
  //   await _tacheService.updateTacheStatus(tache.id, true);
  //   Navigator.pop(context); // Retour à l'écran précédent
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Tâche marquée comme faite')),
  //   );
  // }

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
)

      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text('Titre : ${tache.title}', 
      //           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 10),
      //       Text('Contenu : ${tache.content}', 
      //           style: const TextStyle(fontSize: 16)),
      //       const SizedBox(height: 10),
      //       // Text('Date : ${_formatDate(tache.date as DateTime?)}',
      //       Text('Date : ${_formatDate(tache.date as DateTime?)}',
      //           style: const TextStyle(fontSize: 16, color: Colors.grey)),

      //       const Spacer(), // Pour pousser les boutons en bas
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           ElevatedButton.icon(
      //             onPressed: () => _deleteTache(context),
      //             icon: const Icon(Icons.delete, color: Colors.red),
      //             label: const Text('Supprimer'),
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.white,
      //               foregroundColor: Colors.red,
      //             ),
      //           ),
      //           ElevatedButton.icon(
      //             onPressed: () => _markAsDone(context),
      //             icon: const Icon(Icons.check, color: Colors.green),
      //             label: const Text('Fait'),
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: Colors.white,
      //               foregroundColor: Colors.green,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    
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
