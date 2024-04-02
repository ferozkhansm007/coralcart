import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/screens/checkout_screen.dart';
import 'package:coralcart/screens/payment_screen.dart';
import 'package:coralcart/services/firbase_cart_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  double total = 0;
  List<DocumentSnapshot>cartChekout =[];

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
            .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).where('status',isEqualTo: 'pending')
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

          snapshot.data!.docs.forEach(
            (element) {
              double subtotal = double.parse(element['subtotal']);
              total = subtotal + total;
            },
          );
          

          cartChekout=snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Total Amount  :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Rs.$total',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var cartItem = snapshot.data!.docs[index];
                    var productname = cartItem['productname'];
                    var price = double.parse(cartItem['price']);

                    return CartItemTile(
                      productname: productname,
                      price: price.toDouble(),
                      subtotal: cartItem['subtotal'].toString(),
                      imageUrl: cartItem['imageUrl'],
                      quantity: cartItem['quantity'],
                      add: () {
                        total=0;
                        FirebaseCartService().addQuantity(
                            cartid: cartItem.id,
                            quantity: cartItem['quantity'],
                            price: cartItem['price']);
                      },
                      minus: () {
                        total=0;
                        FirebaseCartService().minusQuantity(
                            cartid: cartItem.id,
                            quantity: cartItem['quantity'],
                            price: cartItem['price']);
                      },
                      onDelete: () {
                        FirebaseCartService().removeCartItem(cartItem.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CheckoutScreen(cartItems: cartChekout,total: total,)),
          );
        },
        label: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.payment, color: Colors.white),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CartItemTile extends StatelessWidget {
  final String productname;
  final double price;
  final String imageUrl;
  final String subtotal;
  final VoidCallback onDelete;
  final VoidCallback add;
  final VoidCallback minus;
  final String quantity;

  const CartItemTile({
    required this.productname,
    required this.price,
    required this.imageUrl,
    required this.onDelete,
    required this.subtotal,
    required this.quantity,
    required this.add,
    required this.minus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 4,
         color: Colors.white, // Set the background color to white
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.teal, width: 1), // Add a teal-colored border
      borderRadius: BorderRadius.circular(8), // Adjust the border radius as needed
    ),
        
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),
          title: Text(productname),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price: \Rs.${price.toStringAsFixed(2)}'),
              Text('subtotal:\Rs. ${subtotal}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                color: Colors.black,
                onPressed: minus,
              ),
              Text(
                quantity,
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.add),
                color: Colors.black,
                onPressed: add,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.black,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
