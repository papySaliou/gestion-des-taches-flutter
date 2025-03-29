import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testapi/views/login_screen.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode privée pour gérer les erreurs Firebase
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Cet email est déjà enregistré.';
      case 'weak-password':
        return 'Le mot de passe est trop faible.';
      case 'invalid-email':
        return "Le format de l'email est invalide.";
      case 'user-not-found':
        return "Aucun utilisateur trouvé avec cet email.";
      case 'wrong-password':
        return "Le mot de passe est incorrect.";
      default:
        return 'Une erreur inattendue est survenue. Veuillez réessayer.';
    }
  }

  // Inscription avec Firebase Auth et ajout dans Firestore
  Future<String> signUpUser({
    required String email,
    required String password,
    required String nom,
    required String telephone,
    required String nomUtilisateur,
    Uint8List? profileImage,
  }) async {
    try {
      if ([email, password, nom, telephone, nomUtilisateur]
          .any((field) => field.trim().isEmpty)) {
        return 'Veuillez remplir tous les champs.';
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      String? base65Image =
          profileImage != null ? base64Encode(profileImage) : null;

      await _firestore.collection("userData").doc(uid).set({
        'uid': uid,
        'Nom Complet': nom,
        'Telephone': telephone,
        // 'Nom Utilisateur': nomUtilisateur,
        'Date Inscription': Timestamp.now(),
        'Rôle': 'Utilisateur',
        'photoBase64': base65Image,
      });

      return 'Inscription réussie !';
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    } catch (err) {
      return 'Une erreur inattendue est survenue. Veuillez réessayer.';
    }
  }

  // Connexion utilisateur
  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if ([email, password].any((field) => field.trim().isEmpty)) {
        return {'error': 'Veuillez remplir tous les champs.'};
      }

      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection("userData").doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>;
        userData['uid'] = uid;
        return userData;
      } else {
        return {'error': 'Données utilisateur introuvables.'};
      }
    } on FirebaseAuthException catch (e) {
      return {'error': _handleAuthException(e)};
    } catch (err) {
      return {'error': 'Une erreur inattendue est survenue. Veuillez réessayer.'};
    }
  }

  // Déconnexion
  Future<void> signOutUser({
    required BuildContext context,
  }) async {
    await _auth.signOut();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
