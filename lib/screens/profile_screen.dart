import 'package:coralcart/screens/your_orders.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue, // Add a background color
              child: Icon(
                Icons.person, // Use the user icon
                size: 50,
                color: Colors.white, // Set icon color to white
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Davood Ibrahim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Daoddibrahim@gmail.com',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('View Orders'),
              onTap: () {
               
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserOrdersScreen(),
                        ));

              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Edit Profile'),
              onTap: () {
                // Navigate to edit profile screen
              },
            ),
          ],
        ),
      ),
    );
  }
}




