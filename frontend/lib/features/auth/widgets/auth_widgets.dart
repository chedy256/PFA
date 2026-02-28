import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfa/core/theme/app_colors.dart';
import 'package:pfa/core/theme/app_text_styles.dart';
import 'package:pfa/core/utils/validators.dart';

class RoleSelector extends StatefulWidget {
  final ValueChanged<String>? onRoleChanged;

  const RoleSelector({super.key, this.onRoleChanged});

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  // Default selected role
  String _selectedRole = 'Etudiant';

  final List<String> _roles = ['Etudiant', 'Enseignant'];

  @override
  Container build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.cardBackground,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _roles.map((role) {
          final isSelected = _selectedRole == role;
          return Expanded(
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    _selectedRole = role;
                  });
                  if (widget.onRoleChanged != null) {
                    widget.onRoleChanged!(role);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: theme.scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(6),
                          ),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        )
                      : null,
                  child: Text(
                    role,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyMedium?.color?.withValues(
                              alpha: 0.6,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class PasswordInputField extends StatefulWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PasswordInputField({
    super.key,
    required this.label,
    this.validator,
    this.controller,
  });

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
            ),
          ),
        ),
      ),
      obscureText: _obscureText,
      validator: widget.validator ?? Validators.validatePassword,
    );
  }
}

class EmailInputField extends StatelessWidget {
  final TextEditingController? controller;

  const EmailInputField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
    );
  }
}

class NameInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;

  const NameInputField({super.key, this.controller, this.label});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: controller,
      decoration: InputDecoration(
        labelText: label ?? 'Nom',
        prefixIcon: const Icon(Icons.person_outline_rounded),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) => Validators.validateName(value, label ?? 'Nom'),
    );
  }
}

class QuickLoginOptions extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onMicrosoftTap;

  const QuickLoginOptions({
    super.key,
    required this.onGoogleTap,
    required this.onMicrosoftTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          'Ou connectez-vous avec',
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialLoginButton(
              icon: FontAwesomeIcons.google,
              color: Colors.red,
              onTap: onGoogleTap,
            ),
            SocialLoginButton(
              icon: FontAwesomeIcons.microsoft,
              color: const Color(0xFF0072C6),
              onTap: onMicrosoftTap,
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.icon,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        height: 60,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            if (!isDark)
              const BoxShadow(
                color: Colors.grey,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        child: FaIcon(icon, size: 32, color: color),
      ),
    );
  }
}

class CallToActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CallToActionButton(
    this.text,
    this.onPressed, {
    super.key,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double targetWidth = (MediaQuery.of(context).size.width * 0.8).clamp(
      250.0,
      450.0,
    );

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(targetWidth, 60),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: theme.colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: AppTextStyles.callToActionButton.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
    );
  }
}
