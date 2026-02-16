import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Initialize Google Sign In if needed
      await _googleSignIn.initialize();

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // Get the authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential using the ID token
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Microsoft (with domain restriction)
  Future<UserCredential> signInWithMicrosoft() async {
    try {
      // Define the provider
      final microsoftProvider = OAuthProvider('microsoft.com');
      microsoftProvider.setCustomParameters({'prompt': 'select_account'});
      // Use signInWithProvider (for generic OAuth flows)
      final UserCredential userCredential = await _firebaseAuth
          .signInWithProvider(microsoftProvider);

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
    await _googleSignIn.disconnect();
    await _firebaseAuth.signOut();
  }
}
