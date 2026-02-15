import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfa/core/auth/auth_service.dart';

// Defines the application user model that combines Firebase Auth data and Role
class AppUser {
  final String uid;
  final String email;
  final String role;
  // Add other fields from backend if needed

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });
}
class AuthNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    // Listen to auth state changes to persist/restore session
    final authService = ref.watch(authServiceProvider);

    // Set up listener for auth state changes
    authService.authStateChanges.listen((User? firebaseUser) {
      if (firebaseUser == null) {
        state = const AsyncValue.data(null);
      } else {
        // If firebase user exists, we might still need to fetch the role from Backend.
        // For now, we restore state assuming they are logged in.
        state = AsyncValue.data(AppUser(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          role: 'Etudiant', // Default/Placeholder until backend sync
        ));
      }
    });

    // Return initial state based on current user
    final currentUser = authService.currentUser;
    if (currentUser == null) {
      return null;
    }

    return AppUser(
      uid: currentUser.uid,
      email: currentUser.email!,
      role: 'Etudiant', // Default/Placeholder until backend sync
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithEmailAndPassword(email, password);
      //TODO:check the role of the user in the backend and sync data      
      state = AsyncValue.data(AppUser(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        role: 'Etudiant', // Placeholder
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signUpWithEmailAndPassword(email, password);

      // TODO:  signup user in backend with role and sync data
      state = AsyncValue.data(AppUser(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        role: role,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithGoogle();
      // TODO: Sync with backend
      state = AsyncValue.data(AppUser(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        role: 'Etudiant', // Default or prompt user?
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithMicrosoft() async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithMicrosoft();
      // TODO: Sync with backend
      state = AsyncValue.data(AppUser(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        role: 'Etudiant', // Default or prompt user?
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    state = const AsyncValue.data(null);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(() {
  return AuthNotifier();
});
