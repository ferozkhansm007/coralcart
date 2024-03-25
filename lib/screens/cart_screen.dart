import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Cart is empty'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var cartItem = snapshot.data!.docs[index] ;
              var productname = cartItem['productname'];
              var price = double.parse(cartItem['price']);
              
            

              return CartItemTile(
                productname: productname,
                price: price.toDouble(),
                subtotal: cartItem['subtotal'].toString(),
                imageUrl: cartItem['imageUrl'],
                onDelete: () {
                  // Implement logic to remove item from cart
                  // Example: FirebaseFirestore.instance.collection('cart').doc(cartItem.id).delete();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final String productname;
  final double price;
  final String imageUrl;
  final String subtotal;
  final VoidCallback onDelete;

  const CartItemTile({
    required this.productname,
    required this.price,
    required this.imageUrl,
    required this.onDelete,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(productname),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${price.toStringAsFixed(2)}'),
            Text('subtotal: \$${subtotal}'),
            
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.black,
          onPressed: onDelete,
        ),
      ),
    );
  }
}
