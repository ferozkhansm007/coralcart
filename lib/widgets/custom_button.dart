import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,this.height
  });
  final String buttonName;
  final VoidCallback onPressed;
  final double ? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height:height?? 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 52, 171, 159),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6))),
        onPressed:onPressed,
        child: Text(
          buttonName,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}