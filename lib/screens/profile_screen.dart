import 'package:coralcart/screens/edit_profile.dart';
import 'package:coralcart/screens/your_orders.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/services/firebase_auth_services.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('userRegistration')
            .doc(FirebaseAuthService().getUserId())
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            // Wrap with Center widget
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    userData['name'],
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${userData['email']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Phone Number: ${userData['phoneNumber']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Address: ${userData['address']}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                 
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserOrdersScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.teal, // Set background color to teal
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white, // Set icon color to white
                        ),
                        SizedBox(width: 5), // Add spacing between icon and text
                        Text(
                          'Your Orders',
                          style: TextStyle(
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                      ],
                    ),
                  ),
                   ElevatedButton(
                    onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => 
                     EditScreen(username: 'name', 
                     email: 'email', 
                     phone: 'phoneNumber', 
                     address: 'address',),));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.teal, // Set background color to teal
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.accessibility_new_outlined,
                          color: Colors.white, // Set icon color to white
                        ),
                        SizedBox(width: 5), // Add spacing between icon and text
                        Text(
                          'Edit Your Profile',
                          style: TextStyle(
                            color: Colors.white, // Set font color to white
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
