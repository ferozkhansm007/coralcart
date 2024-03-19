import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonName,
    required this.onPressed,
  });
  final String buttonName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 52, 171, 159),
            shape: BeveledRectangleBorder(
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