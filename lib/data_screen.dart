import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'dart:convert';

import 'package:testapi/views/profile_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final String apiUrl = 'http://localhost:3000/task';


  Future<List<Map<String, dynamic>>> fetchData() async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('tasks').get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  } catch (e) {
    print('Erreur de récupération des données : $e');
    return [];
  }
}


  // Future<List<dynamic>> fetchData() async {
  //   try {
  //     final response = await http.get(Uri.parse(apiUrl));
  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       throw Exception('Erreur lors du chargement des données: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Erreur de connexion: $e');
  //     return [];  // Retourne une liste vide en cas d'erreur
  //   }
  // }

Future<void> addTask(String title, String description, String priority, String date) async {
  try {
    await FirebaseFirestore.instance.collection('tasks').add({
      'title': title,
      'description': description,
      'priority': priority,
      'dueDate': date,
    });
    setState(() {}); // Rafraîchir l'UI
  } catch (e) {
    print('Erreur lors de l\'ajout : $e');
  }
}



  // Future<void> addTask(String title, String description, String priority, String date) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'title': title,
  //         'description': description,
  //         'priority': priority,
  //         'date': date,
  //       }),
  //     );


Future<void> updateTask(String id, String title, String description) async {
  try {
    await FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'title': title,
      'description': description,
    });
    setState(() {}); // Rafraîchir l'UI
  } catch (e) {
    print('Erreur lors de la mise à jour : $e');
  }
}



  // Future<void> updateTask(String id, String title, String description) async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$apiUrl/$id'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'title': title, 'description': description}),
  //     );

  //     if (response.statusCode == 200) {
  //       setState(() {});
  //     } else {
  //       throw Exception('Erreur lors de la modification de la tâche');
  //     }
  //   } catch (e) {
  //     print('Erreur : $e');
  //   }
  // }





Future<void> deleteTask(String id, String taskTitle) async {
  bool confirmDelete = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirmer la suppression'),
      content: Text('Voulez-vous vraiment supprimer la tâche "$taskTitle" ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmDelete == true) {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(id).delete();
      setState(() {}); // Rafraîchir l'UI
    } catch (e) {
      print('Erreur lors de la suppression : $e');
    }
  }
}


  // Future<void> deleteTask(String id, String taskTitle) async {
  //   bool confirmDelete = await showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Confirmer la suppression'),
  //       content: Text('Voulez-vous vraiment supprimer la tâche "$taskTitle" ?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context, false),
  //           child: Text('Annuler'),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => Navigator.pop(context, true),
  //           child: Text('Supprimer', style: TextStyle(color: Colors.red)),
  //         ),
  //       ],
  //     ),
  //   );

  //   if (confirmDelete == true) {
  //     try {
  //       final response = await http.delete(Uri.parse('$apiUrl/$id'));
  //       if (response.statusCode == 200) {
  //         setState(() {});
  //       } else {
  //         throw Exception('Erreur lors de la suppression de la tâche');
  //       }
  //     } catch (e) {
  //       print('Erreur : $e');
  //     }
  //   }
  // }

  void showAddTaskDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priorityController = TextEditingController();
    final TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter une tâche'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController, 
              decoration: InputDecoration(
                labelText: 'Titre')),
            TextField(
              controller: descriptionController, 
              decoration: InputDecoration(
                labelText: 'Description')),
            TextField(
              controller: priorityController, 
              decoration: InputDecoration(
                labelText: 'Priorité')),
            TextField(
              controller: dateController, 
              decoration: InputDecoration(
                labelText: 'Date (ex : JJ/MM/AAAA)')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez remplir tous les champs')),
                );
                return;
              }

              addTask(
                titleController.text,
                descriptionController.text,
                priorityController.text,
                dateController.text,
              );
              Navigator.pop(context);
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void showUpdateTaskDialog(String id, String currentTitle, String currentDescription) {
    final TextEditingController titleController = TextEditingController(text: currentTitle);
    final TextEditingController descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier la tâche'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Titre')),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Veuillez remplir tous les champs')),
                );
                return;
              }
              updateTask(id, titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue,
        title: Text('Liste des tâches',
         style: 
        TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          
          ),
         
          ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 20 , left: 20),
            icon: const Icon(Icons.person,
            size: 40,
            color: Colors.white,),

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
        ),
      // body: FutureBuilder<List<dynamic>>(
      //   future: fetchData(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date : ${item['dueDate'] ?? 'Non précisée'}'),
                      ],
                    ),
                    
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showUpdateTaskDialog(
                            item['id'].toString(),
                            item['title'] ?? '',
                            item['description'] ?? '',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(
                            item['id'].toString(),
                            item['title'] ?? 'Sans titre',
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
        onPressed: showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
