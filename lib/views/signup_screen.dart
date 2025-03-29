// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:testapi/services/auth_service.dart';
import 'package:testapi/views/login_screen.dart';
import 'package:testapi/widgets/my_button.dart';
import 'package:testapi/widgets/snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nomController = TextEditingController();
  TextEditingController nomUtilisateurController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;
  final AuthService _authService = AuthService();

  // signup function to handle user registration

void _signUp() async {
  setState(() {
    isLoading = true;
  });
  Uint8List? profileImageBytes;

  print("Tentative d'inscription..."); // ✅ Vérifie si cette ligne apparaît

  final result = await _authService.signUpUser(
    email: emailController.text,
    password: passwordController.text,
    nom: nomController.text,
    telephone: telephoneController.text,
    nomUtilisateur: nomUtilisateurController.text,
    profileImage: profileImageBytes,
  );

  print("Résultat de l'inscription : $result"); // ✅ Vérifie si cette ligne apparaît

  if (result == "success") {
    setState(() {
      isLoading = false;
    });

    print("Inscription réussie, redirection..."); // ✅ Vérifie si cette ligne apparaît

    showSnackBar(context, "Signup successful! Now turn to Login");

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  } else {
    setState(() {
      isLoading = false;
    });

    print("Erreur lors de l'inscription : $result"); // ✅ Vérifie si cette ligne apparaît

    showSnackBar(context, "Signup failed: $result");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(

             child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset("assets/images/4957136.jpg",
              height: 150,
              width: 100,),
              const SizedBox( height: 20),
              // input field for name 
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                   hintText: "Nom",
                    prefixIcon:  Icon(Icons.lock),
                  // labelText: "Nom",
                  // border: OutlineInputBorder(),
                ),
              ),
              const SizedBox( height: 20),

              // input field for Telephone 
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                   hintText: "Telephone",
                    prefixIcon: Icon(Icons.phone),
                  // labelText: "Nom",
                  // border: OutlineInputBorder(),
                ),
              ),
              const SizedBox( height: 20),
              // input field for email 
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                   hintText: "Email",
                      prefixIcon:  Icon(Icons.email_outlined),
                  // labelText: "Email",
                  // border: OutlineInputBorder(),
                ),
              ),
              const SizedBox( height: 20),
              // input field for password
               TextField(
                controller: passwordController,
                decoration:  InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  // labelText: "Password",
                  // border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    }, 
                    icon: Icon(
                      isPasswordHidden 
                      ? Icons.visibility_off
                       :Icons.visibility,
                       ),
                    ),
                ),
                obscureText: isPasswordHidden,
              ),
              
              const SizedBox( height: 20),
  
                // for signup button

                isLoading 
                ? const Center(
                  child: CircularProgressIndicator(),
                ) : SizedBox(width: double.infinity,
              child: MyButton(
                onTap: _signUp, 
                buttontext: "Signup"),
                ),
                const SizedBox( height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Already have an account? ", 
                    style: TextStyle(
                    fontSize: 18),
                  ),
                  GestureDetector( 
                    onTap: () {
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) =>  const LoginScreen(),
                      ),
                      );
                  },
                  child: Text(
                    "Login here", 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, 
                      letterSpacing: -1
                  ),),
                  )
                  ],
                  ),
            ],
          ),
          ),

        ),

          ),
    );
  }
}