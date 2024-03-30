import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen(
      {Key? key, required this.orderId, required this.orderData})
      : super(key: key);

  // Method to cancel the order
  void _cancelOrder(BuildContext context) {
    // Implement your cancellation logic here, such as updating order status or deleting it
    // For example, you can delete the order from Firestore using the orderId
    FirebaseFirestore.instance.collection('orders').doc(orderId).delete();

    // After cancellation, you can navigate back to the previous screen or perform any other action as needed
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Address: ${orderData['address']}'),
            Text('Booking Time: ${orderData['bookingtime']}'),
            Text('Payment Method: ${orderData['paymentmethod']}'),
            Text('Status: ${orderData['status']}'),
            Text('Total: ${orderData['total']}'),

            Text('My products', style: TextStyle(fontSize: 18)),
            Column(
              children: orderData['productlist']
                  .map<Widget>((e) => Text(e['productname']))
                  .toList(),
            ),
            SizedBox(height: 20),
            // Cancel Order button
            GestureDetector(
              onTap: () {
                _cancelOrder(context); // Call the cancel order method
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Cancel Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
