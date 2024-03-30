import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCartService {
// Function to add an item to the cart collection in Firestore
  Future<void> addCart(
      {required String productId,
      required String productName,
      required String price,
      required String imageUrl,
      required String sellerid}) async {
    try {
      // Get the current user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Check if the item is already in the cart
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('productid', isEqualTo: productId)
          .where('userid', isEqualTo: userId).where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          int currentQuantity = int.parse(doc.get('quantity')) + 1;
          int currentPrice = int.parse(doc.get('price'));
          FirebaseFirestore.instance.collection('cart').doc(doc.id).update({
            'quantity': currentQuantity.toString(),
            'subtotal': (currentQuantity * currentPrice).toString()
          });
        });
      } else {
        await FirebaseFirestore.instance.collection('cart').doc().set({
          'userid': userId,
          'productid': productId,
          'productname': productName,
          'price': price,
          'imageUrl': imageUrl,
          'quantity': '1',
          'subtotal': price,
          'status': 'pending',
          'sellerid':sellerid
        });
      }
    } catch (error) {
      print('Error adding item to cart: $error');
      // Handle error
    }
  }

  Future<void> addQuantity(
      {required String cartid,
      required String quantity,
      required String price}) async {
    try {
      int currentQuantity = int.parse(quantity) + 1;
      int currentPrice = int.parse(price);
      FirebaseFirestore.instance.collection('cart').doc(cartid).update({
        'quantity': currentQuantity.toString(),
        'subtotal': (currentQuantity * currentPrice).toString()
      });
    } catch (e) {}
  }
  Future<void> minusQuantity(
      {required String cartid,
      required String quantity,
      required String price}) async {
    try {
     if ( int.parse(quantity)>= 2){
      int currentQuantity = int.parse(quantity) - 1;
      int currentPrice = int.parse(price);
      FirebaseFirestore.instance.collection('cart').doc(cartid).update({
        'quantity': currentQuantity.toString(),
        'subtotal': (currentQuantity * currentPrice).toString()
      });
     }
     
    } catch (e) {
      rethrow;
    }
  }
  Future<void> removeCartItem(String cartItemId) async {
    try {
      await FirebaseFirestore.instance.collection('cart').doc(cartItemId).delete();
    } catch (error) {
      print('Error removing item from cart: $error');
      // Handle error
    }
  }
  


}

