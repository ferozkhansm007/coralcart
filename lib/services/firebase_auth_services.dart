import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStore =FirebaseFirestore.instance;
  Future<void> register({
  required String name,
  required String address,
  required String password,
  required String phoneNumber,
  required String email,
}) async {
  try {
    // Create user with Firebase Authentication
    var userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    var user = userCredential.user;

    await _firebaseStore.collection('userRegistration').doc(user!.uid).set({
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'password' : password
    });

    print('rrrrrrr');

    await _firebaseStore.collection('logintb').doc(user.uid).set({
      'userid': user.uid,
      'email': email,
      'password' : password,
      'status':0,
      'role':'user'
    });
  } catch (e) {
    print(e);
    
    rethrow;
  }
}
  Future<void> login({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }
}
