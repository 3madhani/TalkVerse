abstract class AuthRepo {
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void > signInWithGoogle();

  Future<void> signInWithFacebook();

  Future<void> signOut();
}