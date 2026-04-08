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
  late final ProviderSubscription<AsyncValue<AppUser?>> _authSubscription;

  bool _isLogin = true;
  String _selectedRole = 'Etudiant';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _authSubscription = ref.listenManual(
      authProvider,
      _onAuthStateChanged,
      fireImmediately: true,
    );
  }

  void _onAuthStateChanged(
    AsyncValue<AppUser?>? previous,
    AsyncValue<AppUser?> next,
  ) {
    if (!mounted) {
      return;
    }

    if (next.hasError) {
      if (kDebugMode) {
        print('Authentication Error: ${next.error}');
      }
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(next.error?.toString() ?? 'An error occurred'),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      return;
    }

    if (next.value != null && !next.isLoading) {
      final userRole = next.value!.role;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        switch (userRole) {
          case 'Etudiant':
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/student',
              (Route<dynamic> route) => false,
            );
            break;
          case 'Enseignant':
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/teacher',
              (Route<dynamic> route) => false,
            );
            break;
          default:
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (Route<dynamic> route) => false,
            );
        }
      });
    }
  }

  @override
  void dispose() {
    _authSubscription.close();
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

  void _onRoleChanged(String role) {
    _selectedRole = role;
  }

  void _onForgotPasswordTap() {
    Navigator.pushNamed(context, '/resetpass');
  }

  void _onGoogleTap() {
    ref.read(authProvider.notifier).loginWithGoogle(_selectedRole);
  }

  void _onMicrosoftTap() {
    ref.read(authProvider.notifier).loginWithMicrosoft(_selectedRole);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _AuthFormContent(
                formKey: _formKey,
                isLogin: _isLogin,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                onRoleChanged: _onRoleChanged,
                onForgotPasswordTap: _onForgotPasswordTap,
                onToggleAuthMode: _toggleAuthMode,
                onSubmit: _submit,
                onGoogleTap: _onGoogleTap,
                onMicrosoftTap: _onMicrosoftTap,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthFormContent extends StatelessWidget {
  const _AuthFormContent({
    required this.formKey,
    required this.isLogin,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onRoleChanged,
    required this.onForgotPasswordTap,
    required this.onToggleAuthMode,
    required this.onSubmit,
    required this.onGoogleTap,
    required this.onMicrosoftTap,
  });

  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String> onRoleChanged;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onToggleAuthMode;
  final VoidCallback onSubmit;
  final VoidCallback onGoogleTap;
  final VoidCallback onMicrosoftTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AutofillGroup(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _LogoSection(),
            const SizedBox(height: 24),
            RoleSelector(onRoleChanged: onRoleChanged),
            isLogin
                ? _LoginSection(
                    emailController: emailController,
                    passwordController: passwordController,
                    onForgotPasswordTap: onForgotPasswordTap,
                    onGoogleTap: onGoogleTap,
                    onMicrosoftTap: onMicrosoftTap,
                  )
                : _SignupSection(
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
            _AuthModeToggleButton(
              isLogin: isLogin,
              onPressed: onToggleAuthMode,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 18),
            _AuthSubmitButton(isLogin: isLogin, onSubmit: onSubmit),
          ],
        ),
      ),
    );
  }
}

class _LoginSection extends StatelessWidget {
  const _LoginSection({
    required this.emailController,
    required this.passwordController,
    required this.onForgotPasswordTap,
    required this.onGoogleTap,
    required this.onMicrosoftTap,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onForgotPasswordTap;
  final VoidCallback onGoogleTap;
  final VoidCallback onMicrosoftTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        EmailInputField(controller: emailController),
        const SizedBox(height: 16),
        PasswordInputField(
          label: 'Mot de passe',
          controller: passwordController,
        ),
        _ForgotPasswordRow(onPressed: onForgotPasswordTap),
        const SizedBox(height: 12),
        QuickLoginOptions(
          onGoogleTap: onGoogleTap,
          onMicrosoftTap: onMicrosoftTap,
        ),
      ],
    );
  }
}

class _SignupSection extends StatelessWidget {
  const _SignupSection({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const _SignupNameRow(),
        const SizedBox(height: 16),
        EmailInputField(controller: emailController),
        const SizedBox(height: 16),
        PasswordInputField(
          label: 'Mot de passe',
          controller: passwordController,
        ),
        const SizedBox(height: 16),
        PasswordInputField(
          label: 'Confirmer le mot de passe',
          controller: confirmPasswordController,
          validator: (value) =>
              Validators.validatePasswordMatch(value, passwordController.text),
        ),
        const SizedBox(height: 34),
      ],
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 128,
      child: Center(child: Image(image: AssetImage('assets/images/logo.png'))),
    );
  }
}

class _SignupNameRow extends StatelessWidget {
  const _SignupNameRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: NameInputField(
            label: 'Prénom',
            autofillHints: [AutofillHints.givenName],
          ),
        ),
        Expanded(
          child: NameInputField(
            label: 'Nom',
            autofillHints: [AutofillHints.familyName],
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordRow extends StatelessWidget {
  const _ForgotPasswordRow({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Mot de passe oubliée?',
            style: TextStyle(
              fontFamily: AppFonts.outfit,
              decoration: TextDecoration.underline,
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}

class _AuthModeToggleButton extends StatelessWidget {
  const _AuthModeToggleButton({
    required this.isLogin,
    required this.onPressed,
    required this.color,
  });

  final bool isLogin;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        isLogin ? "Vous n'avez pas de compte?" : 'Vous avez déjà un compte?',
        style: TextStyle(
          fontFamily: AppFonts.outfit,
          fontSize: 16,
          decoration: TextDecoration.underline,
          color: color,
        ),
      ),
    );
  }
}

class _AuthSubmitButton extends ConsumerWidget {
  const _AuthSubmitButton({required this.isLogin, required this.onSubmit});

  final bool isLogin;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      authProvider.select((state) => state.isLoading),
    );

    return CallToActionButton(
      isLogin ? 'Se Connecter' : 'S\'inscrire',
      onSubmit,
      isLoading: isLoading,
    );
  }
}
