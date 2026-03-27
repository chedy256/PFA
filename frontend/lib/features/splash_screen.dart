import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pfa/core/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    // Simulate some future initialization work
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authState = ref.read(authProvider);

    // Fallback if loading, wait for it
    if (authState.isLoading) {
      // Just let the auth guard in routes do the work if we pushed login?
      // Actually ref.watch in build is better, but since it's a future delayed:
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    authState.whenData((user) {
      if (user != null) {
        if (user.role == 'Etudiant') {
          Navigator.pushReplacementNamed(context, '/student');
        } else if (user.role == 'Enseignant') {
          Navigator.pushReplacementNamed(context, '/teacher');
        } else {
          Navigator.pushReplacementNamed(context, '/login');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
