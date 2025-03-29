import 'package:flutter/material.dart';
import 'package:testapi/services/auth_service.dart';
import 'package:testapi/views/nab_bar_category_selection_screen.dart';
import 'package:testapi/views/signup_screen.dart';
import 'package:testapi/widgets/my_button.dart';
import 'package:testapi/widgets/snackbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordHidden = true;
  final AuthService _authService = AuthService();

  

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await _authService.loginUser(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NabBarCategorySelectionScreen(),
        ),
      );
    } else {
      showSnackBar(context, "Login failed: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/3094352.jpg",
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 20),

                  // Champ Email
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez saisir votre email";
                      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(value)) {
                        return "Veuillez saisir un email valide";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Champ Mot de passe
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => isPasswordHidden = !isPasswordHidden);
                        },
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: isPasswordHidden,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez saisir votre mot de passe";
                      } else if (value.length < 6) {
                        return "Le mot de passe doit comporter au moins 6 caractères";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Bouton "Mot de passe oublié"
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: TextButton(
                  //     onPressed: () {
                  //       // Ajoute ici la navigation vers l'écran de réinitialisation du mot de passe
                  //       showSnackBar(context, "Fonctionnalité à venir...");
                  //     },
                  //     child: const Text(
                  //       "Mot de passe oublié ?",
                  //       style: TextStyle(color: Colors.blue),
                  //     ),
                  //   ),
                  // ),

                  // Indicateur de chargement ou bouton de connexion
                  isLoading
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: MyButton(
                            onTap: _login,
                            buttontext: "Login",
                          ),
                        ),

                  const SizedBox(height: 20),

                  // Lien vers l'inscription
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Signup here",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
