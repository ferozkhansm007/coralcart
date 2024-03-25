import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseCartService {

// Function to add an item to the cart collection in Firestore
Future<void> addCart({required String productId,required String productName,required String price,required String imageUrl}) async {
  try {
    // Get the current user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Check if the item is already in the cart
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('cart')
      .where('productid', isEqualTo: productId)
      .where('userid', isEqualTo: userId)
      .get();
       

    if (querySnapshot.docs.isNotEmpty) {
      
       querySnapshot.docs.forEach((doc) {


           int currentQuantity= int.parse(doc.get('quantity')) + 1;
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
        'subtotal': price
        
      });
      
      
    }
  } catch (error) {
    print('Error adding item to cart: $error');
    // Handle error
  }
}





}