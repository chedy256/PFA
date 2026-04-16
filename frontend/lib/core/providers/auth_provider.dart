import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pfa/core/auth/auth_service.dart';

import 'package:pfa/core/services/backend_auth_service.dart';

// Defines the application user model that combines Firebase Auth data and Role
class AppUser {
  final String uid;
  final String email;
  final String role;
  final String? firstName;
  final String? lastName;

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
  });
}

class AuthNotifier extends AsyncNotifier<AppUser?> {
  final _storage = const FlutterSecureStorage();
  final _backendAuthService = BackendAuthService();

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

        try {
          final userData = await _backendAuthService.getMe();
          state = AsyncValue.data(
            AppUser(
              uid: firebaseUser.uid,
              email: firebaseUser.email!,
              role: userData['role'] ?? 'student',
              firstName: userData['first_name'],
              lastName: userData['last_name'],
            ),
          );
        } catch (e) {
          state = AsyncValue.data(
            AppUser(
              uid: firebaseUser.uid,
              email: firebaseUser.email!,
              role: 'student', // Fallback
            ),
          );
        }
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

    try {
      final userData = await _backendAuthService.getMe();
      return AppUser(
        uid: currentUser.uid,
        email: currentUser.email!,
        role: userData['role'] ?? 'student',
        firstName: userData['first_name'],
        lastName: userData['last_name'],
      );
    } catch (e) {
      return AppUser(
        uid: currentUser.uid,
        email: currentUser.email!,
        role: 'student',
      );
    }
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

      final userData = await _backendAuthService.bootstrap(
        role: role.toLowerCase() == 'enseignant' ? 'teacher' : 'student',
      );

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: userData['role'] ?? role,
          firstName: userData['first_name'],
          lastName: userData['last_name'],
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signup(
    String email,
    String password,
    String firstName,
    String lastName,
    String role,
  ) async {
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

      final userData = await _backendAuthService.bootstrap(
        role: role.toLowerCase() == 'enseignant' ? 'teacher' : 'student',
        firstName: firstName,
        lastName: lastName,
      );

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: userData['role'] ?? role,
          firstName: userData['first_name'],
          lastName: userData['last_name'],
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

      final user = credential.user;
      String firstName = '';
      String lastName = '';
      if (user != null &&
          user.displayName != null &&
          user.displayName!.isNotEmpty) {
        final nameParts = user.displayName!.split(' ');
        firstName = nameParts.first;
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      final userData = await _backendAuthService.bootstrap(
        role: role.toLowerCase() == 'enseignant' ? 'teacher' : 'student',
        firstName: firstName,
        lastName: lastName,
      );

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: userData['role'] ?? role,
          firstName: userData['first_name'],
          lastName: userData['last_name'],
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

      final user = credential.user;
      String firstName = '';
      String lastName = '';
      if (user != null &&
          user.displayName != null &&
          user.displayName!.isNotEmpty) {
        final nameParts = user.displayName!.split(' ');
        firstName = nameParts.first;
        lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      }

      final userData = await _backendAuthService.bootstrap(
        role: role.toLowerCase() == 'enseignant' ? 'teacher' : 'student',
        firstName: firstName,
        lastName: lastName,
      );

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: userData['role'] ?? role,
          firstName: userData['first_name'],
          lastName: userData['last_name'],
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
