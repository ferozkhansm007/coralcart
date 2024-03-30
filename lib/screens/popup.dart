import 'package:flutter/material.dart';

void showOrderPlacedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Order Placed'),
        content: Text('You have successfully placed your order.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void main() {
  runApp(MaterialApp(
    home: OrderPlacedPage(),
  ));
}

class OrderPlacedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Placed'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showOrderPlacedDialog(context);
          },
          child: Text('Place Order'),
        ),
      ),
    );
  }
}
