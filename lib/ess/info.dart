
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Info extends StatelessWidget {
  const Info({super.key, required Map userData});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      // appBar: AppBar(title: const Text("Profil de l'utilisateur")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users') // Replace 'users' with your Firestore collection name
            .doc(user?.uid) // Use the user's UID to fetch their document
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Aucune information utilisateur trouvée."));
          }

          // Retrieve user data from Firestore
          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.person, size: 25,),
                  title: const Text("Nom",
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(userData['nom'] ?? "Non renseigné",
                  style: TextStyle(fontSize: 18),),
                ),
                ListTile(
                  leading: const Icon(Icons.phone ,size: 25,),
                  title: const Text("Téléphone",
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    ),
                    ),

                  subtitle: Text(userData['telephone'] ?? "Non renseigné",
                  style: TextStyle(fontSize: 18),),
                ),
                ListTile(
                  leading: const Icon(Icons.email, size: 25,),
                  title: const Text("Email",
                  style: TextStyle(
                    fontSize: 18, 
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    ),),

                  subtitle: Text(user?.email ?? "Non renseigné",
                  style: TextStyle(fontSize: 18,),),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}  
