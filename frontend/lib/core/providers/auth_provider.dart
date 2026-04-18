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
          final fetchedFirstName = userData['first_name'];
          final fetchedLastName = userData['last_name'];
          final fetchedRole = userData['role'] ?? 'student';

          if (fetchedFirstName != null) {
            await _storage.write(key: 'firstName', value: fetchedFirstName);
          }
          if (fetchedLastName != null) {
            await _storage.write(key: 'lastName', value: fetchedLastName);
          }
          await _storage.write(key: 'role', value: fetchedRole);

          state = AsyncValue.data(
            AppUser(
              uid: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              role: fetchedRole,
              firstName: fetchedFirstName,
              lastName: fetchedLastName,
            ),
          );
        } catch (e, _) {
          print('Error getting user details: $e');
          // Read from storage as fallback
          final savedRole = await _storage.read(key: 'role') ?? 'student';
          final savedFirstName = await _storage.read(key: 'firstName');
          final savedLastName = await _storage.read(key: 'lastName');

          state = AsyncValue.data(
            AppUser(
              uid: firebaseUser.uid,
              email: firebaseUser.email ?? '',
              role: savedRole,
              firstName: savedFirstName,
              lastName: savedLastName,
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
      final fetchedRole = userData['role'] ?? 'student';
      final fetchedFirstName = userData['first_name'];
      final fetchedLastName = userData['last_name'];

      if (fetchedFirstName != null) {
        await _storage.write(key: 'firstName', value: fetchedFirstName);
      }
      if (fetchedLastName != null) {
        await _storage.write(key: 'lastName', value: fetchedLastName);
      }
      await _storage.write(key: 'role', value: fetchedRole);

      return AppUser(
        uid: currentUser.uid,
        email: currentUser.email!,
        role: fetchedRole,
        firstName: fetchedFirstName,
        lastName: fetchedLastName,
      );
    } catch (e) {
      final savedRole = await _storage.read(key: 'role') ?? 'student';
      final savedFirstName = await _storage.read(key: 'firstName');
      final savedLastName = await _storage.read(key: 'lastName');
      return AppUser(
        uid: currentUser.uid,
        email: currentUser.email!,
        role: savedRole,
        firstName: savedFirstName,
        lastName: savedLastName,
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

      String fetchedRole = role.toLowerCase() == 'enseignant'
          ? 'teacher'
          : 'student';
      String? fetchedFirstName;
      String? fetchedLastName;

      try {
        final userData = await _backendAuthService.bootstrap(role: fetchedRole);
        if (userData['role'] != null) fetchedRole = userData['role'];
        if (userData['first_name'] != null && userData['first_name'].toString().isNotEmpty) {
          fetchedFirstName = userData['first_name'];
        }
        if (userData['last_name'] != null && userData['last_name'].toString().isNotEmpty) {
          fetchedLastName = userData['last_name'];
        }

        if (fetchedFirstName != null) {
          await _storage.write(key: 'firstName', value: fetchedFirstName);
        }
        if (fetchedLastName != null) {
          await _storage.write(key: 'lastName', value: fetchedLastName);
        }
        await _storage.write(key: 'role', value: fetchedRole);
      } catch (backendError) {
        print('Backend bootstrap failed during login: $backendError');
        fetchedFirstName = await _storage.read(key: 'firstName');
        fetchedLastName = await _storage.read(key: 'lastName');
        final savedRole = await _storage.read(key: 'role');
        if (savedRole != null) fetchedRole = savedRole;
      }

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: fetchedRole,
          firstName: fetchedFirstName,
          lastName: fetchedLastName,
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

      await _storage.write(key: 'firstName', value: firstName);
      await _storage.write(key: 'lastName', value: lastName);
      await _storage.write(
        key: 'role',
        value: role.toLowerCase() == 'enseignant' ? 'teacher' : 'student',
      );

      String fetchedRole = role.toLowerCase() == 'enseignant'
          ? 'teacher'
          : 'student';
      String fetchedFirstName = firstName;
      String fetchedLastName = lastName;

      try {
        final userData = await _backendAuthService.bootstrap(
          role: fetchedRole,
          firstName: firstName,
          lastName: lastName,
        );
        if (userData['role'] != null) fetchedRole = userData['role'];
        if (userData['first_name'] != null && userData['first_name'].toString().isNotEmpty) {
          fetchedFirstName = userData['first_name'];
        }
        if (userData['last_name'] != null && userData['last_name'].toString().isNotEmpty) {
          fetchedLastName = userData['last_name'];
        }
      } catch (backendError) {
        print('Backend bootstrap failed during signup: $backendError');
      }

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: fetchedRole,
          firstName: fetchedFirstName,
          lastName: fetchedLastName,
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
      } else if (user != null && user.email != null) {
        firstName = user.email!.split('@').first;
      }

      String fetchedRole = role.toLowerCase() == 'enseignant' ? 'teacher' : 'student';
      String fetchedFirstName = firstName;
      String fetchedLastName = lastName;

      try {
        final userData = await _backendAuthService.bootstrap(
          role: fetchedRole,
          firstName: firstName,
          lastName: lastName,
        );
        if (userData['role'] != null) fetchedRole = userData['role'];
        if (userData['first_name'] != null && userData['first_name'].toString().isNotEmpty) {
          fetchedFirstName = userData['first_name'];
        }
        if (userData['last_name'] != null && userData['last_name'].toString().isNotEmpty) {
          fetchedLastName = userData['last_name'];
        }
      } catch (backendError) {
        print('Backend bootstrap failed during login provider: $backendError');
      }

      await _storage.write(key: 'firstName', value: fetchedFirstName);
      await _storage.write(key: 'lastName', value: fetchedLastName);
      await _storage.write(key: 'role', value: fetchedRole);

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: fetchedRole,
          firstName: fetchedFirstName,
          lastName: fetchedLastName,
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
      } else if (user != null && user.email != null) {
        firstName = user.email!.split('@').first;
      }

      String fetchedRole = role.toLowerCase() == 'enseignant' ? 'teacher' : 'student';
      String fetchedFirstName = firstName;
      String fetchedLastName = lastName;

      try {
        final userData = await _backendAuthService.bootstrap(
          role: fetchedRole,
          firstName: firstName,
          lastName: lastName,
        );
        if (userData['role'] != null) fetchedRole = userData['role'];
        if (userData['first_name'] != null && userData['first_name'].toString().isNotEmpty) {
          fetchedFirstName = userData['first_name'];
        }
        if (userData['last_name'] != null && userData['last_name'].toString().isNotEmpty) {
          fetchedLastName = userData['last_name'];
        }
      } catch (backendError) {
        print('Backend bootstrap failed during login provider: $backendError');
      }

      await _storage.write(key: 'firstName', value: fetchedFirstName);
      await _storage.write(key: 'lastName', value: fetchedLastName);
      await _storage.write(key: 'role', value: fetchedRole);

      state = AsyncValue.data(
        AppUser(
          uid: credential.user!.uid,
          email: credential.user!.email!,
          role: fetchedRole,
          firstName: fetchedFirstName,
          lastName: fetchedLastName,
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
    await _storage.delete(key: 'firstName');
    await _storage.delete(key: 'lastName');
    await _storage.delete(key: 'role');
    state = const AsyncValue.data(null);
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AppUser?>(() {
  return AuthNotifier();
});
