import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo authRepo;

  AuthProvider({required this.authRepo});

  UserEntity? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void _setUser(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _setError(null);
    final result = await authRepo.createUserWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      (failure) => _setError(failure.message),
      (userEntity) => _setUser(userEntity),
    );
    _setLoading(false);
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true);
    _setError(null);
    final result = await authRepo.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => _setError(failure.message),
      (userEntity) => _setUser(userEntity),
    );
    _setLoading(false);
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _setError(null);
    final result = await authRepo.signInWithGoogle();
    result.fold(
      (failure) => _setError(failure.message),
      (userEntity) => _setUser(userEntity),
    );
    _setLoading(false);
  }

  Future<void> signInWithFacebook() async {
    _setLoading(true);
    _setError(null);
    final result = await authRepo.signInWithFacebook();
    result.fold(
      (failure) => _setError(failure.message),
      (userEntity) => _setUser(userEntity),
    );
    _setLoading(false);
  }

  Future<void> signOut() async {
    _setLoading(true);
    final result = await authRepo.signOut();
    result.fold((failure) => _setError(failure.message), (_) => _setUser(null));
    _setLoading(false);
  }
}
