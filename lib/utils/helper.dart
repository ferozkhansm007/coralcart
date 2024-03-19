import 'package:firebase_auth/firebase_auth.dart';

String? emailValidator(String value) {
  if (value.isEmpty) {
    return "Please fill the field";
  } else {
    bool ismatch = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (ismatch == false) {
      return "Please check your email address";
    }else{
      return  null;
    }
  }
}
String? validatePassword(String value){
  if(value.isEmpty){
    return "fill the value";
  }else{
    if(value.length<8){
      return "minimum 8 characters";
    }else{
      return null;
    }
  }
}
String getFirebaseAuthErrorMessage(dynamic e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      default:
        return 'Firebase Authentication Error: ${e.code}';
    }
  } else {
    return 'something went wrong';
  }
}
