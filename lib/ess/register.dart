import 'package:flutter/material.dart';
import 'package:testapi/ess/Auth.dart';
import 'package:testapi/ess/authservice.dart';
import 'package:testapi/widgets/my_button.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool isPasswordHidden = true;

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        String? uid = await _authService.registerWithEmail(
          nom: _nameController.text.trim(),
          telephone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (uid != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inscription réussie ! Veuillez vous connecter.'),
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Auth()),
          );
        } else {
          _showError("Échec de l'inscription. Veuillez réessayer.");
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez saisir votre email";
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return "Veuillez saisir un email valide";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez saisir votre numéro de téléphone";
    }
    final phoneRegex = RegExp(r'^[0-9]{9,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return "Veuillez saisir un numéro de téléphone valide";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/3230320.jpg",
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nom',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator:
                        (value) =>
                            value == null || value.isEmpty
                                ? "Veuillez saisir votre nom"
                                : null,
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Téléphone',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 10),

                   TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    obscureText: true,
                    validator: _validateEmail,
                  ),
                  

                  const SizedBox(height: 10),

                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: isPasswordHidden,
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

                  _isLoading
                      ? const CircularProgressIndicator()
                      : MyButton(
                        onTap: _handleRegister,
                        buttontext: 'S\'inscrire',
                      ),

                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Vous avez déjà un compte ? ",
                        style: TextStyle(fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Auth(),
                            ),
                          );
                        },
                        child: const Text(
                          "Connectez-vous ici",
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
