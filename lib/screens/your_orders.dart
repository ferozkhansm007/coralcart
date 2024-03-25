import 'package:flutter/material.dart';

class UserOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: 5, // Replace with the actual number of user orders
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/order_image.png'), // Replace with the actual image
            ),
            title: Text('Order ${index + 1}'),
            subtitle: Text('Order details'), // Replace with actual order details
            onTap: () {
              // Implement navigation to order details screen
            },
          );
        },
      ),
    );
  }
}
