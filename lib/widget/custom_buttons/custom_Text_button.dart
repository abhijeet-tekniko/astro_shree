import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final String? iconPath;
  final Color? textColor;
  final Color color;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final bool? border;

  const CustomTextButton({
    Key? key,
    required this.text,
    this.iconPath,
    this.textColor,
    required this.color,
    required this.onPressed,
    this.height,
    this.width,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height:height,
        padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
          border: border == true ? Border.all(color: Colors.grey) : null, // Conditional border
        ),
        child:
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null)
                Image.asset(
                  iconPath!,
                  height: 24.0,
                  width: 24.0,
                ),
              if (iconPath != null) SizedBox(width: 4.0),
              Flexible(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor ?? Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}