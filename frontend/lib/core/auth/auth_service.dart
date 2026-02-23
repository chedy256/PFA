import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with Email and Password
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Re-throw to handle in UI/Provider
      rethrow;
    }
  }

  // Sign up with Email and Password
  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web: Use Firebase Auth directly with popup
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _firebaseAuth.signInWithPopup(googleProvider);
      } else {
        // Native: Use google_sign_in package
        //initialize the GoogleSignIn instance before calling authenticate
        await _googleSignIn.initialize();
        
        final GoogleSignInAccount googleUser = await _googleSignIn
            .authenticate();

        // Get the authentication tokens
        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        // Create a new credential using the ID token
        final OAuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );
        // Sign in to Firebase with the Google credential
        return await _firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Microsoft (with domain restriction)
  Future<UserCredential> signInWithMicrosoft() async {
    try {
      // Define the provider
      final microsoftProvider = MicrosoftAuthProvider();
      microsoftProvider.setCustomParameters({'prompt': 'select_account'});

      // Use the appropriate sign-in method based on platform
      final UserCredential userCredential;
      if (kIsWeb) {
        userCredential = await _firebaseAuth.signInWithPopup(microsoftProvider);
      } else {
        userCredential = await _firebaseAuth.signInWithProvider(
          microsoftProvider,
        );
      }

      final user = userCredential.user;

      if (user != null && user.email != null) {
        // Enforce domain check
        if (!user.email!.endsWith('@isimm.u-monastir.tn')) {
          // If invalid domain, delete/sign out user immediately
          await user.delete();
          // OR await _firebaseAuth.signOut(); // If delete is too aggressive
          throw FirebaseAuthException(
            code: 'INVALID_DOMAIN',
            message: 'Only @isimm.u-monastir.tn accounts are allowed.',
          );
        }
      }
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    // Only disconnect Google Sign-In on native platforms
    if (!kIsWeb) {
      await _googleSignIn.disconnect();
    }
    await _firebaseAuth.signOut();
  }
}
