import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigate(BuildContext context) async {
    // Simulate some future initialization work (e.g., loading resources, checking auth status, connectivity ,etc.)
    await Future.delayed(const Duration(seconds: 3));

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate(context);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/splash.json',
              repeat: true,
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          Positioned(
            bottom: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: .center,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'ISIMM',
                    style: TextStyle(
                      fontFamily: 'Enza-Bold',
                      fontSize: 36,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                    children: [
                      TextSpan(
                        text: ' INTERN',
                        style: TextStyle(
                          fontFamily: 'Grift',
                          fontSize: 37,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Gestion des stages à l'ISIMM",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
