import 'package:coralcart/screens/card_payment.dart';
import 'package:coralcart/screens/home_screen.dart';
import 'package:coralcart/screens/root_screen.dart';
import 'package:coralcart/screens/your_orders.dart';
import 'package:coralcart/services/firbase_cart_service.dart';
import 'package:coralcart/services/firebase_order_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.address,  
  required this.productList, 
  required this.Total, required this.cartidlist});


  final String address;
  final List productList;
  final List cartidlist;
  final String Total;


  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod ='UPI' ;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Set app bar background color to teal
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RadioListTile(
              title: const Text('UPI'),
              value: 'UPI',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value.toString();
                });
              },
              activeColor: Colors.teal,
            ),
            if (_selectedPaymentMethod == 'UPI')
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter UPI number',
                ),
                onChanged: (value) {
                  // Handle UPI number input
                },
                
              ),
            RadioListTile(
              title: const Text('Credit / Debit Card'),
              value: 'Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value.toString();
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => cardScreen(),
                        ));
                });
              },
              activeColor: Colors.teal,
            ),
            RadioListTile(
              title: const Text('Cash on Delivery'),
              value: 'COD',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value.toString();

                  print(_selectedPaymentMethod);
                });
              },
              activeColor: Colors.teal,
            ),
            const Spacer(),
            loading? const Center(child: CircularProgressIndicator()) : ElevatedButton(
              onPressed: ()  async{
                
                setState(() {
                  loading = true;
                });

               await  Future.delayed(Duration(seconds: 2));
                
                await FirebaseOrderServices().placeOrder(cartidlist: widget.cartidlist, address: widget.address,paymentMethod:_selectedPaymentMethod,total:widget.Total,productList: widget.productList);
                // Show custom pop-up message
                      await showDialog(
                        barrierDismissible:false ,
                        context: context,
                        builder: (BuildContext context) {
                          return PopScope(
                            canPop: false,
                            child: AlertDialog(
                              title: const Text('Order Placed!'),
                              content: const Text('Your order has been successfully placed.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    
                                   Navigator.pushAndRemoveUntil(context,  MaterialPageRoute(
                            builder: (context) => RootScreen(),
                                                    ), (route) => false);
                                    // Navigate back to home or any other screen
                                    // Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                     
                setState(() {
                  loading=false;
                });


                
              },
              child: const Text('Place Your Order',
              style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Set button color to teal
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
            ),
          ],
        ),
      ),
    );
  }
}

