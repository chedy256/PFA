import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final String email;
  final String role;

  User({required this.email, required this.role});
}

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data(User(email: email, role: 'Etudiant'));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> signup(String email, String password, String role) async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(seconds: 1));
      state = AsyncValue.data(User(email: email, role: role));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});
