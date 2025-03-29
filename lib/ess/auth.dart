import 'package:flutter/material.dart';
import 'package:testapi/ess/authservice.dart';
// import 'package:testapi/ess/info.dart';
import 'package:testapi/ess/register.dart';
// import 'package:testapi/views/data_screens.dart';
import 'package:testapi/widgets/my_button.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool isPasswordHidden = true;

  final _formKey = GlobalKey<FormState>(); // Clé du formulaire pour la validation

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) { // Vérifie la validité du formulaire
      setState(() => _isLoading = true);

      try {
        Map<String, dynamic>? userData = await _authService.loginWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (userData != null) {
          Navigator.pushReplacementNamed(context, '/home');
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     // builder: (context) => Info(userData: userData),
          //     builder: (context) => DataScreens(),
          //   ),
          // );
        } else {
          _showError("Échec de la connexion. Vérifiez vos identifiants.");
        }
      } catch (e) {
        _showError("Erreur : ${e.toString()}");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Connexion")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Lien avec la clé du formulaire pour la validation
          child: Column(
            children: [
              Image.asset(
                    "assets/images/3094352.jpg",
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 20),
              // Champ Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez saisir votre email";
                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return "Veuillez saisir un email valide";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ Mot de passe
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: "Mot de passe",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => isPasswordHidden = !isPasswordHidden);
                    },
                    icon: Icon(
                      isPasswordHidden ? Icons.visibility_off : Icons.visibility,
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

              // Indicateur de chargement ou bouton de connexion
              _isLoading
                  ? const CircularProgressIndicator()
                  : MyButton(
                onTap: _handleLogin, 
                buttontext:
                    'Connexion', 
              ), 
              const SizedBox(height: 20),

              // Lien vers l'inscription
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Pas encore de compte ? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Register(),
                        ),
                      );
                    },
                    child: const Text(
                      "S'inscrire ici",
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
    );
  }
}
