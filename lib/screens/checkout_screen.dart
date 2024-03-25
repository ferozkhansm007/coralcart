import 'package:coralcart/screens/payment_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Set app bar background color to teal
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white), // Set text color to white
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
            CheckoutItemTile(
              productName: 'Product 1',
              price: 10.0,
              quantity: 2,
              imageUrl: 'https://via.placeholder.com/150',
            ),
            SizedBox(height: 10),
            CheckoutItemTile(
              productName: 'Product 2',
              price: 20.0,
              quantity: 1,
              imageUrl: 'https://via.placeholder.com/150',
            ),
            SizedBox(height: 10),
            CheckoutItemTile(
              productName: 'Product 3',
              price: 30.0,
              quantity: 1,
              imageUrl: 'https://via.placeholder.com/150',
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$70.00',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
                        SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter your address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement logic for adding address
              },
              child: Text('Submit Address'),
            ),
           

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(),
                        ));
                // Implement logic for placing the order
              },
              child: Text('Place Order'),
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

  const CheckoutItemTile({
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(productName),
        subtitle: Text('Price: \$${price.toStringAsFixed(2)}\nQuantity: $quantity'),
      ),
    );
  }
}
