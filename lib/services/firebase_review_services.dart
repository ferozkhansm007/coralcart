import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseReviewService {
  

  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStore = FirebaseFirestore.instance;

  String? getUserId() {
    return _firebaseAuth.currentUser?.uid;
  }
  Future<void> storeReview({
    required String productId,
    required String sellerId,
    required double rating,
    required String review,
  
  }) async {
    try {

      var data  = await FirebaseAuthService().getUser();
      _firebaseStore.collection('Review').add({
        'userId': getUserId(), // Current user's ID
        'productId': productId,
        'sellerId': sellerId,
        'rating': rating,
        'review': review,
        'name' : data['name']
       
      });
    } catch (e) {
      rethrow;
    }
  }
}
