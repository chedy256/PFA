import 'package:flutter/foundation.dart' show kDebugMode;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage('assets/images/logo.png'), context);
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
            .login(
              _emailController.text,
              _passwordController.text,
              _selectedRole,
            );
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
    final theme = Theme.of(context);

    // Listen for Authentication State Changes
    ref.listen(authProvider, (previous, next) {
      if (next.hasError) {
        if (kDebugMode) {
          print('Authentication Error: ${next.error}');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error?.toString() ?? 'An error occurred'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      } else if (next.value != null && !next.isLoading) {
        // Temporary routing based on the selected role
        switch (_selectedRole) {
          case 'Etudiant':
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/student',
              (Route<dynamic> route) => false, // Clears the entire stack
            );
            break;
          case 'Enseignant':
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/teacher',
              (Route<dynamic> route) => false, // Clears the entire stack
            );
            break;
          default:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/unknown',
              (Route<dynamic> route) => false, // Clears the entire stack
            );
        }
      }
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 128,
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
                          Expanded(child: NameInputField(label: 'Prénom')),
                          Expanded(child: NameInputField(label: 'Nom')),
                        ],
                      ),
                    const SizedBox(height: 16),
                    EmailInputField(controller: _emailController),
                    const SizedBox(height: 16),
                    PasswordInputField(
                      label: 'Mot de passe',
                      controller: _passwordController,
                    ),
                    if (!_isLogin) ...[
                      const SizedBox(height: 16),
                      PasswordInputField(
                        label: 'Confirmer le mot de passe',
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
                                child: Text(
                                  'Mot de passe oubliée?',
                                  style: TextStyle(
                                    fontFamily: AppFonts.outfit,
                                    decoration: TextDecoration.underline,
                                    color: theme.textTheme.bodyMedium?.color
                                        ?.withValues(alpha: 0.6),
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
                      QuickLoginOptions(
                        onGoogleTap: () {
                          ref
                              .read(authProvider.notifier)
                              .loginWithGoogle(_selectedRole);
                        },
                        onMicrosoftTap: () {
                          ref
                              .read(authProvider.notifier)
                              .loginWithMicrosoft(_selectedRole);
                        },
                      ),
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        _isLogin
                            ? "Vous n'avez pas de compte?"
                            : "Vous avez déjà un compte?",
                        style: TextStyle(
                          fontFamily: AppFonts.outfit,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          color: theme.textTheme.bodyMedium?.color?.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    CallToActionButton(
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
