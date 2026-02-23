import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/providers/auth_provider.dart';
import 'package:pfa/features/auth/widgets/auth_widgets.dart';
import 'package:pfa/core/utils/validators.dart';

import '../../core/theme/app_fonts.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isLogin = true;
  String _selectedRole = 'Etudiant';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isLogin) {
        ref
            .read(authProvider.notifier)
            .login(_emailController.text, _passwordController.text);
      } else {
        ref
            .read(authProvider.notifier)
            .signup(
              _emailController.text,
              _passwordController.text,
              _selectedRole,
            );
      }
    }
  }

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for Authentication Errors
    ref.listen(authProvider, (previous, next) {
      if (next.hasError) {
        if (kDebugMode) {
          print('Authentication Error: ${next.error}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error?.toString() ?? 'An error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    RoleSelector(
                      onRoleChanged: (role) {
                        _selectedRole = role;
                      },
                    ),
                    const SizedBox(height: 16),
                    if (!_isLogin)
                      Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: nameInputField(label: 'Prénom')),
                          Expanded(child: nameInputField(label: 'Nom')),
                        ],
                      ),
                    const SizedBox(height: 16),
                    emailInputField(controller: _emailController),
                    const SizedBox(height: 16),
                    passwordInputField(
                      'Mot de passe',
                      controller: _passwordController,
                    ),
                    if (!_isLogin) ...[
                      const SizedBox(height: 16),
                      passwordInputField(
                        'Confirmer le mot de passe',
                        controller: _confirmPasswordController,
                        validator: (value) => Validators.validatePasswordMatch(
                          value,
                          _passwordController.text,
                        ),
                      ),
                    ],
                    _isLogin
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/resetpass');
                                },
                                child: const Text(
                                  'Mot de passe oubliée?',
                                  style: TextStyle(
                                    fontFamily: AppFonts.outfit,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(height: 2),
                    _isLogin
                        ? const SizedBox(height: 12)
                        : const SizedBox(height: 32),
                    if (_isLogin)
                      quickLoginOptions(
                        onGoogleTap: () {
                          ref.read(authProvider.notifier).loginWithGoogle();
                        },
                        onMicrosoftTap: () {
                          ref.read(authProvider.notifier).loginWithMicrosoft();
                        },
                      ),
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        _isLogin
                            ? "Vous n'avez pas de compte?"
                            : "Vous avez déjà un compte?",
                        style: const TextStyle(
                          fontFamily: AppFonts.outfit,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    callToActionButton(
                      context,
                      _isLogin ? 'Se Connecter' : 'S\'inscrire',
                      _submit,
                      isLoading: authState.isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
