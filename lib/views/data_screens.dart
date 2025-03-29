import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapi/views/add_task.dart';
import 'package:testapi/views/login_screen.dart';
import 'package:testapi/views/update_task.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreens extends StatefulWidget {
  const DataScreens({super.key});

  @override
  _DataScreensState createState() => _DataScreensState();
}

class _DataScreensState extends State<DataScreens> {
  final String apiUrl = 'http://localhost:3000/task';

  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    return jsonDecode(response.body);
  }

  void refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Liste des tâches',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, size: 40, color: Colors.white),

            onPressed: () async {
  try {
    String? userEmail = FirebaseAuth.instance.currentUser?.email;
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Déconnexion réussie pour : $userEmail')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erreur lors de la déconnexion")),
    );
  }
},

          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item['title'] ?? 'Sans titre'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed:
                              () => showDialog(
                                context: context,
                                builder:
                                    (context) => UpdateTaskForm(
                                      id: item['id'].toString(),
                                      currentTitle: item['title'] ?? '',
                                      currentDescription:
                                          item['description'] ?? '',
                                      refreshData: refreshData,
                                    ),
                              ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Aucune tâche trouvée.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => showDialog(
              context: context,
              builder: (context) => AddTaskForm(refreshData: refreshData),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
