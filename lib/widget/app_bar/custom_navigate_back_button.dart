import 'package:flutter/material.dart';

class CustomNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomNavigationButton({
    super.key,
    required this.onPressed,
    this.width = 30.0,
    this.height = 30.0,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFBDBDBD)),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back,size: 20,),
          onPressed: onPressed,
        ),
      ),
    );
  }
}