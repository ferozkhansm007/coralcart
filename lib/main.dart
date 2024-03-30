import 'package:coralcart/firebase_options.dart';
import 'package:coralcart/screens/cart_screen.dart';
import 'package:coralcart/screens/cartsample.dart';
import 'package:coralcart/screens/checkout_screen.dart';
import 'package:coralcart/screens/home_screen.dart';
import 'package:coralcart/screens/login_screen.dart';
import 'package:coralcart/screens/payment_screen.dart';
import 'package:coralcart/screens/profile_screen.dart';
import 'package:coralcart/screens/register_screen.dart';

import 'package:coralcart/screens/root_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: RootScreen(),));
}

