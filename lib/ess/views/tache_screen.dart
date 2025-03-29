import 'package:flutter/material.dart';
import 'package:testapi/ess/models/tache.dart';
import 'package:testapi/ess/services/tache_service.dart';
import 'package:testapi/ess/views/add_tache_screen.dart';
import 'package:testapi/ess/views/details_tache_screen.dart';

class TacheScreen extends StatefulWidget {

  TacheScreen({super.key});

  @override
  State<TacheScreen> createState() => _TacheScreenState();
}

class _TacheScreenState extends State<TacheScreen> {
  final TacheService _tacheService = TacheService();

   // Fonction pour rafraîchir les données
  Future<void> _refreshTaches() async {
    setState(() {});
  }

  // Fonction utilitaire pour formater la date en "jj 2 mois annee""
  String _formatDate(DateTime? date) {
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

  // Fonction pour obtenir la couleur en fonction de la priorité
  Color getPriorityColor(String priority) {
    switch (priority) {
      case "Élevée":
        return Colors.red;
      case "Moyenne":
        return Colors.amberAccent;
      case "Basse":
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Tache>>(
        stream: _tacheService.getTache(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune tâche trouvée.'));
          }

          final taches = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refreshTaches,  // Ajout du refresh
            child: ListView.builder(
              itemCount: taches.length,
              itemBuilder: (context, index) {
                final currentTache = taches[index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            currentTache.title,
                            style: const TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            _formatDate(DateTime.parse(currentTache.date)),
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15,
                            ),
                          ),
                          trailing: Icon(
                            Icons.circle,
                            size: 40,
                            color: getPriorityColor(currentTache.priority),
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailsTacheScreen(tache: currentTache),
                              ),
                            );

                            // Si une action a réussi, on rafraîchit les tâches
                            if (result == true) {
                              _refreshTaches();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddTacheScreen()),
        ),
        child: const Icon(Icons.add,
         color: Colors.white,
         size: 30,),
      ),
    );
  }
}

