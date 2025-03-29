// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapi/ess/models/tache.dart';
import 'package:testapi/ess/services/tache_service.dart';
import 'package:testapi/ess/views/edit_tache_screen.dart';

class DetailsTacheScreen extends StatefulWidget {
  Tache tache;

  DetailsTacheScreen({super.key, required this.tache});

  @override
  State<DetailsTacheScreen> createState() => _DetailsTacheScreenState();
}

class _DetailsTacheScreenState extends State<DetailsTacheScreen> {
  final TacheService _tacheService = TacheService();
   @override
  void initState() {
    super.initState();
  }

  // Supprimer la tâche

void _deleteTache(BuildContext context, String id) async {
  try {
    print("Suppression de la tâche avec ID: ${widget.tache.id}"); // Debug
    await _tacheService.deleteTache(widget.tache.id);
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
  // Mettre à jour l'état dans Firestore
  await _tacheService.updateTacheStatus(widget.tache.id, true);
  setState(() {
    widget.tache.status = true; // Mise à jour de l'état local
  });
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
            Text(
              'Titre : ${widget.tache.title}',
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Contenu : ${widget.tache.content}',
              style: const TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 10),
            Text(
              'Date : ${_formatDate(DateTime.tryParse(widget.tache.date))}',
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _deleteTache(context,widget.tache.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Supprimer"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updatedTache = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTacheScreen(tache: widget.tache),
                      ),
                    );

                    if (updatedTache != null) {
                      setState(() {
                        widget.tache = updatedTache; // Mise à jour de la tâche dans le widget
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Mise à jour"),
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
  String _formatDate(dynamic date) {
    if (date is String) {
      date = DateTime.tryParse(date); // Convertit la chaîne en DateTime
    }

    if (date == null) return 'Date invalide';

    const joursSemaine = [
      'Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi',
    ];

    const moisAnnee = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin', 'juillet', 'août',
      'septembre', 'octobre', 'novembre', 'décembre',
    ];

    String jourSemaine = joursSemaine[date.weekday == 7 ? 0 : date.weekday];
    String mois = moisAnnee[date.month - 1];

    return '$jourSemaine ${date.day} $mois ${date.year}';
  }
}


          


