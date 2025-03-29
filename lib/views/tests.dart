


import 'package:flutter/material.dart';
import 'package:testapi/widgets/custom_input_field.dart';
import 'package:testapi/widgets/my_button.dart';
import 'package:testapi/widgets/snackbar.dart';
import 'package:testapi/services/auth_service.dart';
import 'package:testapi/views/nab_bar_category_selection_screen.dart';
import 'package:testapi/views/signup_screen.dart';

class LoginScreenst extends StatefulWidget {
  const LoginScreenst({super.key});

  @override
  State<LoginScreenst> createState() => _LoginScreenstState();
}

class _LoginScreenstState extends State<LoginScreenst> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final AuthService _authService = AuthService();

  // Fonction de connexion
  void _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showSnackBar(context, "Veuillez remplir tous les champs");
      return;
    }

    setState(() => isLoading = true);

    final result = await _authService.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (result == "success") {
      setState(() => isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const NabBarCategorySelectionScreen(),
        ),
      );
    } else {
      setState(() => isLoading = false);
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
            child: Column(
              children: [
                Image.asset(
                  "assets/images/3094352.jpg",
                  height: 250,
                  width: 250,
                ),
                const SizedBox(height: 20),

                CustomInputField(
                  hintText: "Email",
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                CustomInputField(
                  hintText: "Mot de passe",
                  icon: Icons.lock,
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),

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
    );
  }
}
