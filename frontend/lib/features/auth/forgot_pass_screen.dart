import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfa/features/auth/widgets/auth_widgets.dart';

import '../../core/theme/app_fonts.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: SizedBox(
                height: 110,
                child: Center(
                  child: Image(image: AssetImage('assets/images/logo.png')),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 120),
                      EmailInputField(controller: _emailController),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Vous avez déjà un compte?",
                          style: TextStyle(
                            fontFamily: AppFonts.outfit,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: Color.fromARGB(255, 100, 100, 100),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CallToActionButton('Envoyer', () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text.trim(),
                            );
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Email envoyé'),
                                  content: Text(
                                    'Un email de réinitialisation de mot de passe a été envoyé à ${_emailController.text}. Veuillez vérifier votre boîte de réception.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Close dialog
                                        Navigator.pop(
                                          context,
                                        ); // Go back to previous screen
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            String message = 'Une erreur est survenue.';
                            if (e.code == 'user-not-found') {
                              message =
                                  'Aucun utilisateur trouvé avec cet email.';
                            } else if (e.code == 'invalid-email') {
                              message = 'L\'adresse email est mal formatée.';
                            } else {
                              message = e.message ?? message;
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
