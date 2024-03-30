import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewProductScreen extends StatelessWidget {
  ViewProductScreen({super.key,required this.viewdata});
  Map<String,dynamic> viewdata;
  


  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Section: Image and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  viewdata['image'], // Replace with your image URL, // Replace with your image path
                  height: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewdata['productname'],
                        style: TextStyle(
                          
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        viewdata['price'], // Replace with your price
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        viewdata['discription'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
              
              
              ],
            ),
          ),
          // Bottom Section: Buttons
          
        ],
      ),
    );
  }
}