import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../errors/exception.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await sendEmailVerification(); // ✅ now it's a method inside the class

      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log(
        "FirebaseAuthService.createUserWithEmailAndPassword CustomException: ${e.toString()} code: ${e.code}",
      );
      // Handle Firebase errors
      if (e.code == 'weak-password') {
        throw CustomException(message: 'Your password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(
          message:
              'Your email is already in use. Please use a different email.',
        );
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: 'Your email is not valid.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message: 'Please check your internet connection.',
        );
      } else if (e.code == 'operation-not-allowed') {
        throw CustomException(message: 'Unexpected error, try again later.');
      } else if (e.code == 'too-many-requests') {
        throw CustomException(message: 'Too many requests. Try again later.');
      } else {
        throw CustomException(message: 'An error occurred, try again later.');
      }
    } catch (e) {
      log(
        "FirebaseAuthService.createUserWithEmailAndPassword Error: ${e.toString()}",
      );
      throw CustomException(message: 'Unexpected error, try again later.');
    }
  }

  Future deleteUser() async {
    await _firebaseAuth.currentUser!.delete();
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = math.Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  // isLoggedin
  bool isLoggedIn() => _firebaseAuth.currentUser != null;

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null && !user.emailVerified) {
        await _firebaseAuth.signOut(); // force sign out
        throw CustomException(
          message: 'Please verify your email before logging in.',
        );
      }
      return user!;
    } on FirebaseAuthException catch (e) {
      log(
        "FirebaseAuthService.signInWithEmailAndPassword CustomException: ${e.toString()} code: ${e.code}",
      );
      if (e.code == 'user-not-found') {
        throw CustomException(message: 'Your email is not registered.');
      } else if (e.code.toLowerCase().contains('invalid')) {
        throw CustomException(message: "Your email or password is not valid.");
      } else if (e.code == 'invalid-email') {
        throw CustomException(message: 'Your email is not valid.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(
          message: 'Please check your internet connection.',
        );
      } else if (e.code == 'operation-not-allowed') {
        throw CustomException(message: 'This operation is not allowed.');
      } else if (e.code == 'too-many-requests') {
        throw CustomException(
          message: 'You have made too many requests. Please try again later.',
        );
      } else {
        throw CustomException(message: 'An error occurred, please try again.');
      }
    } catch (e) {
      log(
        "FirebaseAuthService.signInWithEmailAndPassword CustomException: ${e.toString()}",
      );
      throw CustomException(message: 'An error occurred, please try again.');
    }
  }

  Future<User> signInWithFacebook() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final LoginResult loginResult = await FacebookAuth.instance.login(
      nonce: nonce,
    );

    OAuthCredential facebookAuthCredential;

    if (Platform.isIOS) {
      switch (loginResult.accessToken!.type) {
        case AccessTokenType.classic:
          final token = loginResult.accessToken as ClassicToken;
          facebookAuthCredential = FacebookAuthProvider.credential(
            token.authenticationToken!,
          );
          break;
        case AccessTokenType.limited:
          final token = loginResult.accessToken as LimitedToken;
          facebookAuthCredential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: token.tokenString,
            rawNonce: rawNonce,
          );
          break;
      }
    } else {
      facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );
    }
    return (await FirebaseAuth.instance.signInWithCredential(
      facebookAuthCredential,
    )).user!;
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return (await _firebaseAuth.signInWithCredential(credential)).user!;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await FacebookAuth.instance.logOut();
    await GoogleSignIn().signOut();
  }
}
