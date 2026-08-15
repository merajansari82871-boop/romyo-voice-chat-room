import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final AuthService instance = AuthService._();

  AuthService._();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> checkAuthStatus() async {
    return _firebaseAuth.currentUser != null;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'createdAt': DateTime.now(),
        'status': 'offline',
      });

      return true;
    } catch (e) {
      print('Signup Error: $e');
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update status to online
      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update({'status': 'online'});

      return true;
    } catch (e) {
      print('Login Error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Update status to offline
      if (currentUser != null) {
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .update({'status': 'offline'});
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Logout Error: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Get User Data Error: $e');
      return null;
    }
  }
}