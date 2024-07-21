

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {required this.hidden, super.key, this.onChanged, this.hintText, 
      required this.controller,
 
      this.keyboardType=TextInputType.text,
      this.validator
      });
  String? labelText,hintText;
  //String errorMsg;
  bool hidden;
  
  String? Function(String?)? validator;
  TextInputType keyboardType;
   TextEditingController controller=TextEditingController();
  Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08, vertical: 8),
      child: TextFormField(
        obscureText: hidden,
        validator: validator ?? (value) {
          if (value!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
        keyboardType: keyboardType,
        controller: controller ,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: hintText,
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.deepPurple)),
        ),
      ),
    );
  }
}
