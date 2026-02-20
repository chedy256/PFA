import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfa/core/theme/app_colors.dart';
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
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background, // Light grey background for the container
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
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
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: isSelected
                      ? BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        )
                      : null,
                  child: Text(
                    role,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey.shade700,
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

TextFormField passwordInputField(
  String label, {
  String? Function(String?)? validator,
  TextEditingController? controller,
}) => TextFormField(
  controller: controller,
  decoration: InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
    prefixIcon: const Icon(Icons.lock_outline_rounded),
  ),
  obscureText: true,
  validator: validator ?? Validators.validatePassword,
);

TextFormField emailInputField({TextEditingController? controller}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: Validators.validateEmail,
    );

TextFormField nameInputField({TextEditingController? controller, String? label}) =>
    TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label ?? 'Nom',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        prefixIcon: const Icon(Icons.person_outline_rounded),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) => Validators.validateName(value, label ?? 'Nom'),
    );

Column quickLoginOptions({
  required VoidCallback onGoogleTap,
  required VoidCallback onMicrosoftTap,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SocialLoginButton(
            icon: FontAwesomeIcons.google,
            color: Colors.red,
            onTap: onGoogleTap,
          ),
          const SizedBox(width: 24),
          SocialLoginButton(
            icon: FontAwesomeIcons.microsoft,
            color: const Color(0xFF0072C6), // Outlook Blue
            onTap: onMicrosoftTap,
          ),
        ],
      ),
      const SizedBox(height: 24),
    ],
  );
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
  InkWell build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 70,
        width: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FaIcon(icon, size: 32, color: color),
      ),
    );
  }
}

ElevatedButton callToActionButton(
  String text,
  VoidCallback onPressed, {
  bool isLoading = false,
}) => ElevatedButton(
  onPressed: isLoading ? null : onPressed,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.black87,
    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: isLoading
      ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
        )
      : Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
);
