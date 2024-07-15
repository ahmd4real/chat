import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {required this.hidden, super.key, this.onChanged, this.hintText});
  String? hintText;
  bool hidden;
  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.08, vertical: 16),
      child: TextFormField(
        
        obscureText: hidden,
        
        validator: (value) {
          if (value!.isEmpty) {
            return 'Field is Required';
          }
          return null;
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius :BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
            borderRadius :BorderRadius.all(Radius.circular(12)),
              borderSide:
                  BorderSide(color: Colors.deepPurple)),
        ),
      ),
    );
  }
}
