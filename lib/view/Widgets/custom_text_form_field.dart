import 'package:chat/constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.hidden,
    super.key,
    this.onChanged,
    this.hintText,
    required this.controller,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,  this.maxLines, 
     this.prefixIcon,
    
  });

  final String? labelText, hintText;
  final bool hidden;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final int ?maxLines;
  final IconData? prefixIcon;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isHidden;

  @override
  void initState() {
    super.initState();
    isHidden = widget.hidden;
  }

  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.08,
        vertical: 8,
      ),
      child: TextFormField(
       // maxLines: widget.maxLines,
        obscureText: isHidden,
        validator: widget.validator ??
            (value) {
              if (value!.isEmpty) {
                return 'Field is required';
              }
              return null;
            },
        cursorColor: mainColor,
      
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.prefixIcon, color: mainColor,),
          labelText: widget.labelText,
          hintText: widget.hintText,
          
          hintStyle: TextStyle(color: kGrey),
          labelStyle: TextStyle(color: mainColor),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: kGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: mainColor),
          ),
          suffixIcon: widget.hidden
              ? IconButton(
                  icon: Icon(
                    isHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: mainColor,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
