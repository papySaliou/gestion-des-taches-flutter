import 'package:flutter/material.dart';

class Logins extends StatefulWidget {
  const Logins({super.key});

  @override
  State<Logins> createState() => _LoginsState();
}

class _LoginsState extends State<Logins> {
  // Contrôleurs pour gérer les données saisies
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Widget réutilisable pour les champs de texte
  Widget buildInputField({
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword, // Gère les champs de mot de passe
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFFb2b7bf),
            fontSize: 18,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFFb2b7bf)),
        ),
        keyboardType: keyboardType,
        textCapitalization: TextCapitalization.words,
        style: const TextStyle(fontSize: 18, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
  width: MediaQuery.of(context).size.width,
  height: 300,

   // Hauteur définie à 300
  child: Image.asset(
    "assets/images/3094352.jpg",
    // fit: BoxFit.cover,
  ),
),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  buildInputField(
                    hintText: "Nom",
                    icon: Icons.person,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 25),
                  buildInputField(
                    hintText: "Email",
                    icon: Icons.email,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 25),
                  buildInputField(
                    hintText: "Mot de passe",
                    icon: Icons.lock,
                    controller: TextEditingController(),
                    isPassword: true,
                  ),
                  // const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
