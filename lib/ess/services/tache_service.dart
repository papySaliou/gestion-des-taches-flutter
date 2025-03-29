import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testapi/ess/models/tache.dart';

class TacheService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Créer une tâche
  Future<void> addTache(Tache tache) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('taches')
            .doc(user.uid)
            .collection('userTasks')
            .add(tache.toMap());
      } catch (e) {
        print('Erreur lors de l\'ajout de la tâche : $e');
      }
    }
  }

  Future<void> updateTache(Tache tache) async {
    try {
      await _firestore
          .collection('taches')
          .doc(tache.uid) // Use the user's UID
          .collection('userTasks')
          .doc(tache.id) // Use the task's ID
          .update(tache.toMap()); // Update the task with the new data
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }
  // Récupérer les tâches de l'utilisateur
  Stream<List<Tache>> getTache() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('taches')
          .doc(user.uid)
          .collection('userTasks')
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Tache.fromMap(doc.id, doc.data())).toList());
    }
    return const Stream.empty();
  }


  // Update task status
  Future<void> updateTacheStatus(String id, bool status) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Utilisateur non connecté");
    }

    try {
      await _firestore
          .collection('taches')
          .doc(user.uid)
          .collection('userTasks')
          .doc(id)
          .update({'status': status});
      print("Statut de la tâche mis à jour avec succès : $id");
    } catch (e) {
      print("Erreur lors de la mise à jour du statut : $e");
      throw Exception("Erreur de mise à jour : $e");
    }
  }

  // Delete task
  Future<void> deleteTache(String taskId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("Utilisateur non connecté");
    }

    try {
      await _firestore
          .collection('taches')
          .doc(user.uid)
          .collection('userTasks')
          .doc(taskId)
          .delete();
      print("Tâche supprimée avec succès : $taskId");
    } catch (e) {
      print("Erreur lors de la suppression : $e");
      throw Exception("Erreur de suppression : $e");
    }
  }
}
