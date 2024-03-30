import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseOrderServices{
   final _firebaseAuth = FirebaseAuth.instance;
  final firebaseStore =FirebaseFirestore.instance;

Future<void>placeOrder({required List cartidlist, required String address,required String paymentMethod, required String total, required List productList,  })async {

  try{

    var currentUserid= _firebaseAuth.currentUser!.uid;

    

  
    firebaseStore.collection('orders').doc().set({

      'userid': currentUserid,
      'address': address,
      'status': 'pending',
      'isSellerConfirm': false,
      'cartidlist':cartidlist,
      'productlist':productList,
      'paymentmethod':paymentMethod,
      'total':total,
      'bookingtime': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      
      
    }

    
      
    );

   QuerySnapshot cartData = await firebaseStore.collection('cart').where('userid',isEqualTo: currentUserid).where('status',isEqualTo: 'pending').get();

   if(cartData.docs.isNotEmpty){

    cartData.docs.forEach((element) { 


      firebaseStore.collection('cart').doc(element.id).update({
        'status' : 'completed'
      });
    });


   }


  }
  catch(e){

    rethrow;

  }

}
}