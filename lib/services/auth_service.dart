import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateStream => _auth.authStateChanges();

  Future<User> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e));
    }
  }

  Future<User> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e));
    }
  }

  Future<void> signOut() => _auth.signOut();

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e));
    }
  }

  String _friendlyMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'invalid-credential':
        return 'No account matches those credentials.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with that email.';
      case 'weak-password':
        return 'Password is too weak (use at least 6 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }
}
