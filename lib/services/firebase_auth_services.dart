import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStore = FirebaseFirestore.instance;
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
        'password': password
      });

      print('rrrrrrr');

      await _firebaseStore.collection('logintb').doc(user.uid).set({
        'userid': user.uid,
        'email': email,
        'password': password,
        'status': 0,
        'role': 'user'
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

  Future<String> getAddress(String id) async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

      // Get the document snapshot
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firebaseStore.collection('userRegistration').doc(id).get();

      // Check if the document exists
      if (snapshot.exists) {
        // Retrieve the address field from the document data
        String address = snapshot.get('address');
        return address;
      } else {
        print('Document does not exist');
        return ''; // Return an empty string if the document does not exist
      }
    } catch (e) {
      print('Error getting address: $e');
      // Handle error
      rethrow; // Return an empty string in case of error
    }
  }

  String getUserId() {
    return _firebaseAuth.currentUser!.uid;
  }

  Future<Map<String, dynamic>> getUser() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseStore
        .collection('userRegistration')
        .doc(_firebaseAuth.currentUser!.uid)
        .get();
    return snapshot.data()!;
  }

  Future<void> edituserprofile(
      {required String username,
      required String email,
      required String phone,
      required String address}) async {
    try {
      _firebaseStore.collection('userRegistration').doc(getUserId()).update({
        'name': username,
        'email': email,
        'phoneNumber': phone,
        'address': address
      });
    } catch (e) {
      rethrow;
    }
  }
   Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error logging out: $e');
      // Handle error logging out
    }
  }
}
