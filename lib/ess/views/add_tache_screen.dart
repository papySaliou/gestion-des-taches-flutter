import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testapi/ess/models/tache.dart';
import 'package:testapi/ess/services/tache_service.dart';
import 'package:testapi/widgets/my_button.dart';
import 'package:intl/intl.dart';

class AddTacheScreen extends StatefulWidget {
  const AddTacheScreen({super.key});

  @override
  State<AddTacheScreen> createState() => _AddTacheScreenState();
}

class _AddTacheScreenState extends State<AddTacheScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final TacheService _tacheService = TacheService();
  final _formKey = GlobalKey<FormState>();
  DateTime selectedTaskDate = DateTime.now();
  String selectedTaskPriority = 'Moyenne';
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Fonction pour ouvrir le DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTaskDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedTaskDate) {
      setState(() {
        selectedTaskDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedTaskDate); // Mise à jour du champ
      });
    }
  }

  void _addTache() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final tache = Tache(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        date: selectedTaskDate.toIso8601String(),
        priority: selectedTaskPriority,
        uid: user.uid,
      );
      _tacheService.addTache(tache);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur : Aucun utilisateur connecté")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
            backgroundColor: Colors.lightBlue,
        title: const 
      Text('Ajouter une tâche',
      style: TextStyle(color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Champ Titre
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titre de la tâche',
                    hintText: 'Entrer le titre de la tâche',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tu dois compléter ce champ";
                    }
                    return null;
                  },
                  controller: _titleController,
                ),
              ),

              // Champ Contenu
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contenu',
                    hintText: 'Entrer le contenu de la tâche',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tu dois compléter ce champ";
                    }
                    return null;
                  },
                  controller: _contentController,
                ),
              ),

              // Priorité
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField(
                  items: const [
                    DropdownMenuItem(value: 'Élevée', child: Text("Élevée")),
                    DropdownMenuItem(value: 'Moyenne', child: Text("Moyenne")),
                    DropdownMenuItem(value: 'Basse', child: Text("Basse"))
                  ],
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  value: selectedTaskPriority,
                  onChanged: (value) {
                    setState(() {
                      selectedTaskPriority = value!;
                    });
                  },
                ),
              ),

              // Date de la tâche
              Container(
                margin: const EdgeInsets.only(bottom: 25),
                child: TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: "Choisir une date",
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate(context); // Ouvre le DatePicker
                  },
                  readOnly: true, // Empêche l'utilisateur de saisir la date manuellement
                ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.green,
              //       foregroundColor: Colors.white,
              //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     onPressed: () {
              //       if (_formKey.currentState!.validate()) {
              //         ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text("Envoi en cours...")),
              //         );
              //         _addTache(); // Fonction pour ajouter la tâche
              //       }
              //     },
              //     child: const Text(
              //       "VALIDER",
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         fontStyle: FontStyle.italic,
              //         color: Colors.white,
              //         letterSpacing: 2,
              //       ),
              //     ),
              //   ),
              // ),
              MyButton(
  onTap: () {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Envoi en cours...")),
      );
      _addTache(); // Fonction pour ajouter la tâche
    }
  },
  buttontext: "VALIDER",
  // color: Colors.green, // Pour conserver la couleur verte de ton bouton précédent
)
            ],
          ),
        ),
      ),
    );
  }
}