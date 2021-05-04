import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class SignUpFailure implements Exception {}

class LogInWithEmailAndPasswordFailure implements Exception {}

class LogInWithGoogleFailure implements Exception {}

class LogInWithFacebookFailure implements Exception {}

class LogOutFailure implements Exception {}

class SendResetEmailFailure implements Exception {}

class UpdatePasswordFailure implements Exception {}

class AuthenticationRepository {
  static const userCacheKey = '__user_cache_key__';

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FacebookLogin _facebookSignIn;
  final SharedPreferences _storage;

  AuthenticationRepository({
    required SharedPreferences storage,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FacebookLogin? facebookSignIn,
  })  : _storage = storage,
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.standard(),
        _facebookSignIn = facebookSignIn ?? FacebookLogin();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      if (user != User.empty) {
        _storage.setString(userCacheKey, json.encode(user.toJson()));
      }
      return user;
    });
  }

  User get currentUser {
    final String? userJsonEncodedData = _storage.getString(userCacheKey);
    return userJsonEncodedData != null
        ? User.fromJson(json.decode(userJsonEncodedData))
        : User.empty;
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> logInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on Exception {
      throw LogInWithGoogleFailure();
    }
  }

  Future<void> logInWithFacebook() async {
    try {
      final FacebookLoginResult response = await _facebookSignIn.logIn(
          permissions: [
            FacebookPermission.publicProfile,
            FacebookPermission.email
          ]);

      switch (response.status) {
        case FacebookLoginStatus.success:
          final FacebookAccessToken fbToken = response.accessToken!;
          final firebase_auth.AuthCredential authCredential =
              firebase_auth.FacebookAuthProvider.credential(fbToken.token);
          await _firebaseAuth.signInWithCredential(authCredential);
          break;
        case FacebookLoginStatus.cancel:
          break;
        case FacebookLoginStatus.error:
          throw LogInWithFacebookFailure();
      }
    } on Exception {
      throw LogInWithFacebookFailure();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on Exception {
      throw SendResetEmailFailure();
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      final firebase_auth.User? firebaseUser = _firebaseAuth.currentUser;
      await firebaseUser?.updatePassword(password);
    } on Exception {
      throw UpdatePasswordFailure();
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookSignIn.logOut(),
      ]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  // add new custom method
  User get toUser {
    return User(id: uid, email: email, name: displayName);
  }
}
