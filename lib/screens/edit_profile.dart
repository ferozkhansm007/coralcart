import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coralcart/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';

class EditScreen extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String address;

  const EditScreen({
    Key? key,
    required this.username,
    required this.email,
    required this.phone,
    required this.address,
  }) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _loading = false;
  File? _imageFile;

  Future<void> _pickImageFromGallery() async {
    Navigator.pop(context); // Close the bottom sheet
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    _usernameController.text = widget.username;
    _emailController.text = widget.email;
    _phoneController.text = widget.phone;
    _addressController.text = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _imageFile == null
                  ? Stack(
                      children: [],
                    )
                  : Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: 250,
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 20,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                _imageFile = null;
                              });
                            },
                            icon: Icon(
                              Icons.cancel,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        // Regular expression pattern for email validation
                        String emailPattern =
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                        RegExp regex = RegExp(emailPattern);
                        if (!regex.hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone number cannot be empty';
                        }
                        // Regular expression pattern for phone number validation
                        String phonePattern =
                            r'^[0-9]{10}$'; // Assuming 10-digit phone number
                        RegExp regex = RegExp(phonePattern);
                        if (!regex.hasMatch(value)) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Address cannot be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _loading
                        ? CircularProgressIndicator(color: Colors.teal)
                        : ElevatedButton(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                            child: Text('Update Profile'),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

     
     String? userId = FirebaseAuthService().getUserId();

      // Get profile data from text controllers
      String username = _usernameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String address = _addressController.text;

      // Update user's profile in Firestore
      FirebaseFirestore.instance
          .collection('userRegistration')
          .doc(userId)
          .set({
        'name': username,
        'email': email,
        'phoneNumber': phone,
        'address': address,
      }).then((_) {
        // Show success message
        MotionToast.success(
          title: Text("Success"),
          description: Text("Profile updated successfully"),
        ).show(context);

        setState(() {
          _loading = false;
        });
      }).catchError((error) {
        // Show error message
        MotionToast.error(
          title: Text("Error"),
          description: Text("Failed to update profile. $error"),
        ).show(context);

        setState(() {
          _loading = false;
        });
      });
    }
  }
}
