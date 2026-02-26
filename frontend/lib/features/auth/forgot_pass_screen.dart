import 'package:flutter/material.dart';
import 'package:pfa/features/auth/widgets/auth_widgets.dart';

import '../../core/theme/app_fonts.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
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
                height: 128,
                child: Center(
                  child: Image(image: AssetImage('assets/images/logo.png')),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 120),
                    const EmailInputField(),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/login');
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
                    CallToActionButton('Envoier', () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
