import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/screens/payment_screen.dart';
import 'package:coralcart/services/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final List<DocumentSnapshot> cartItems;
  final double total; // Declare a field to hold the cart items

  CheckoutScreen({Key? key, required this.cartItems, required this.total})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? address;

  void getaddress() async {
    address = await FirebaseAuthService()
        .getAddress(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  final _addressController = TextEditingController();
  List productList = [];
  List cartidlist=[];

  @override
  void initState() {
    getaddress();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  var cartItem = widget.cartItems[index];
                  var productName = cartItem['productname'];
                  var price = double.parse(cartItem['price']);
                  var quantity = int.parse(cartItem['quantity']);
                  var imageUrl = cartItem['imageUrl'];
                  if (address != null) {
                    productList.add(
                      {
                        'productname': cartItem['productname'],
                        'productid': cartItem.id,
                        'sellerid': cartItem['sellerid'],
                        'quantity': cartItem['quantity'],
                        'sellerConfirm':false,
                        'subtotal': (price * quantity).toString()
                      },
                    );
                  }
                  return CheckoutItemTile(
                    productName: productName,
                    price: price,
                    quantity: quantity,
                    imageUrl: imageUrl,
                    total: widget.total.toString(),
                  );
                },
              ),
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
                'Rs.${widget.total}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            if (address != null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  address!,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_addressController.text.isNotEmpty) {
                  address = _addressController.text;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      cartidlist: [],
                      address: address!,
                      productList: productList,
                      Total: widget.total.toString(),
                    ),
                  ),
                );
                // Implement logic for placing the order
              },
              child: Text('Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutItemTile extends StatelessWidget {
  final String productName;
  final double price;
  final int quantity;
  final String imageUrl;
  final String total;

  const CheckoutItemTile(
      {required this.productName,
      required this.price,
      required this.quantity,
      required this.imageUrl,
      required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(productName),
        subtitle:
            Text('Price: ${price.toStringAsFixed(2)}\nQuantity: $quantity'),
      ),
    );
  }
}
