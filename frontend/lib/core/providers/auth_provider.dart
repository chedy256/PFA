import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pfa/core/auth/auth_service.dart';

// Defines the application user model that combines Firebase Auth data and Role
class AppUser {
  final String uid;
  final String email;
  final String role;
  // Add other fields from backend if needed

  AppUser({required this.uid, required this.email, required this.role});
}

class AuthNotifier extends AsyncNotifier<AppUser?> {
  final _storage = const FlutterSecureStorage();

  @override
  Future<AppUser?> build() async {
    // Listen to auth state changes to persist/restore session
    final authService = ref.watch(authServiceProvider);

    // Set up listener for auth state changes
    authService.authStateChanges.listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        await _storage.delete(key: 'jwt');

        state = const AsyncValue.data(null);
      } else {
        final token = await firebaseUser.getIdToken();
        if (token != null) {
          await _storage.write(key: 'jwt', value: token);
        }
        // If firebase user exists, we might still need to fetch the role from Backend.
        // For now, we restore state assuming they are logged in.
        state = AsyncValue.data(
          AppUser(
            uid: firebaseUser.uid,
            email: firebaseUser.email!,
            role: 'Etudiant', // Default/Placeholder until backend sync
          ),
        );
      }
    });

    // Return initial state based on current user
    final currentUser = authService.currentUser;
    if (currentUser == null) {
      return null;
    }

    final token = await currentUser.getIdToken();
    if (token != null) {
      await _storage.write(key: 'jwt', value: token);
    }

    return AppUser(
      uid: currentUser.uid,
      email: currentUser.email!,
      role: 'Etudiant', // Default/Placeholder until backend sync
    );
  }

  Future<void> login(String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithEmailAndPassword(
        email,
        password,
      );
      final token = await credential.user!.getIdToken();
      if (token != null) {
        await _storage.write(key: 'jwt', value: token);
      }
      //TODO:check the role of the user in the backend and sync data
      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: role,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signUpWithEmailAndPassword(
        email,
        password,
      );
      final token = await credential.user!.getIdToken();
      if (token != null) {
        await _storage.write(key: 'jwt', value: token);
      }

      // TODO:  signup user in backend with role and sync data
      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: role,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithGoogle(String role) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithGoogle();
      final token = await credential.user!.getIdToken();
      if (token != null) {
        await _storage.write(key: 'jwt', value: token);
      }
      // TODO: Sync with backend
      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: role,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loginWithMicrosoft(String role) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      final credential = await authService.signInWithMicrosoft();
      final token = await credential.user!.getIdToken();
      if (token != null) {
        await _storage.write(key: 'jwt', value: token);
      }
      // TODO: Sync with backend
      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: role, // Default or prompt user?
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.signOut();
    await _storage.delete(key: 'jwt');
    state = const AsyncValue.data(null);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(() {
  return AuthNotifier();
});
