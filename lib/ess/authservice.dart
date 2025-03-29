import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Inscription avec Firebase Auth et ajout dans Firestore
  Future<String?> registerWithEmail({
    required String email,
    required String password,
    required String nom,
    required String telephone,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? uid = userCredential.user?.uid;

      if (uid != null) {
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'nom': nom,
          'telephone': telephone,
          'email': email,
        });

        return uid;
      }
    } on FirebaseAuthException catch (e) {
      print("Erreur FirebaseAuth : ${e.code}");
      return null;
    } catch (e) {
      print("Erreur d'inscription inattendue : $e");
      return null;
    }
    return null;
  }

  // Connexion avec récupération des données utilisateur
  Future<Map<String, dynamic>?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? uid = userCredential.user?.uid;

      if (uid != null) {
        DocumentSnapshot userDoc = 
            await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        } else {
          print("Aucune donnée trouvée pour l'utilisateur avec UID : $uid");
        }
      }
    } on FirebaseAuthException catch (e) {
      print("Erreur FirebaseAuth : ${e.code}");
      return null;
    } catch (e) {
      print("Erreur de connexion inattendue : $e");
      return null;
    }
    return null;
  }
}
