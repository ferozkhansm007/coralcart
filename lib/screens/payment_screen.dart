import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Set app bar background color to teal
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic for payment method 1
              },
              child: Text('UPI'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement logic for payment method 2
              },
              child: Text('Credit / Debit Card'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement logic for payment method 3
              },
              child: Text('Cash on Delivery'),
            ),
          ],
        ),
      ),
    );
  }
}

