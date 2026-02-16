import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/providers/auth_provider.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/features/auth/widgets/auth_widgets.dart';
import 'package:pfa/core/utils/validators.dart';

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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.topCenter,
                  height: 100,
                  child: Center(
                    child: Image(image: AssetImage('assets/images/logo.png')),
                  ),
                ),
              ],
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoleSelector(
                          onRoleChanged: (role) {
                            _selectedRole = role;
                          },
                        ),
                        const SizedBox(height: 16),
                        if (!_isLogin) ...[
                          Row(
                            spacing: 16,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                // Added Expanded
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Prénom',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Nom',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        emailInputField(controller: _emailController),
                        const SizedBox(height: 16),
                        passwordInputField(
                          'Mot de passe',
                          controller: _passwordController,
                        ),
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                              labelText: 'Confirmer le mot de passe',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                              ),
                            ),
                            obscureText: true,
                            validator: (value) =>
                                Validators.validatePasswordMatch(
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
                                      Navigator.pushNamed(
                                        context,
                                        '/resetpass',
                                      );
                                    },
                                    child: const Text(
                                      'Mot de passe oubliée?',
                                      style: TextStyle(
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
                              ref
                                  .read(authProvider.notifier)
                                  .loginWithMicrosoft();
                            },
                          ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _toggleAuthMode,
                          child: Text(
                            _isLogin
                                ? "Vous n'avez pas de compte?"
                                : "Vous avez déjà un compte?",
                            style: const TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                              color: Color.fromARGB(255, 100, 100, 100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        callToActionButton(
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
          ],
        ),
      ),
    );
  }
}
