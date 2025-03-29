import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fonction pour récupérer les données utilisateur depuis Firestore
  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('USER_ID') // Remplace 'USER_ID' par l'ID de l'utilisateur connecté
          .get();

      if (userDoc.exists) {
        final data = userDoc.data();
        setState(() {
          _nameController.text = data?['nom'] ?? '';
          _phoneController.text = data?['telephone'] ?? '';
          _emailController.text = data?['email'] ?? '';
          _profileImage = data?['imageUrl']; // URL de l'image dans Firestore
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Données utilisateur non trouvées"),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors du chargement des données"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fonction pour choisir une image depuis la galerie
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }

  // Fonction pour sauvegarder les données dans Firestore
  Future<void> _saveProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc('USER_ID') // Remplace 'USER_ID' par l'ID de l'utilisateur connecté
          .set({
        'nom': _nameController.text,
        'telephone': _phoneController.text,
        'email': _emailController.text,
        'imageUrl': _profileImage, // Tu peux uploader cette image vers Firebase Storage si nécessaire
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil mis à jour avec succès !"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur lors de la mise à jour du profil"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mon Profil",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _profileImage != null
                    ? FileImage(File(_profileImage!))
                    : null,
                child: _profileImage == null
                    ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Numéro de téléphone"),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
