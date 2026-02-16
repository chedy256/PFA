class Validators {
  // Email regex pattern
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password regex pattern
  // At least 8 characters, 1 uppercase, 1 lowercase, 1 digit
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z]{8,}$',
  );

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email est requis';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer une adresse email valide';
    }
    return null;
  }

  /// Validates password strength
  /// Requires: min 8 chars, 1 uppercase, 1 lowercase, 1 digit
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Au moins 8 caractères sont requis';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Au moins une lettre majuscule est requise';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Au moins une lettre minuscule est requise';
    }
    if (!value.contains(RegExp(r'\d'))) {
      return 'Au moins un chiffre est requis';
    }
    //if (!value.contains(RegExp(r'[@$!%*?&]'))) {return 'Le mot de passe doit contenir au moins un caractère spécial (@\$!%*?&)';}
    return null;
  }

  /// Validates that passwords match
  static String? validatePasswordMatch(String? value, String? passwordValue) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != passwordValue) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}
