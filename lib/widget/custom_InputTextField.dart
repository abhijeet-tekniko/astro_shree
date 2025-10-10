import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Widget inputTextFields({
  final String? title,
  final String? hintText,
  final String? Function(String?)? val,
  final Function()? onTap,
  final TextInputType? inputType,
  final Widget? suffix,
  final Widget? prefix,
  final TextInputAction? inputAction,
  final List<TextInputFormatter>? inputFormatter,
  final bool? readOnly,
  final TextEditingController? textEditingController,
  final int? maxLength,
  final int? maxLines,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: TextFormField(
          validator: val,
          onTap: onTap,
          textCapitalization: TextCapitalization.words,
          controller: textEditingController,
          keyboardType: inputType ?? TextInputType.text,
          maxLength: maxLength,
          maxLines: maxLines ?? 1,
          textInputAction: inputAction ?? TextInputAction.next,
          readOnly: readOnly ?? false,
          inputFormatters: inputFormatter,
          style: const TextStyle(fontSize: 12, color: Colors.black),
          decoration: InputDecoration(
            hintText:hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            labelText: title??hintText,
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10.0),
            ),
            counterText: '',
            suffixIcon: suffix,
            prefixIcon: prefix,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          ),
        ),
      ),
      SizedBox(height: 15),
    ],
  );
}