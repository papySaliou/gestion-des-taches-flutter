import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final Map<String, dynamic> userData;
  const Info({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil de l'utilisateur")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Nom"),
              subtitle: Text(userData['nom'] ?? "Non renseigné"),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text("Téléphone"),
              subtitle: Text(userData['telephone'] ?? "Non renseigné"),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text("Email"),
              subtitle: Text(userData['email'] ?? "Non renseigné"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text("Retour"),
            ),
          ],
        ),
      ),
    );
  }
}
