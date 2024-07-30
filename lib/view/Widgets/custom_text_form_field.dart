import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    required this.hidden,
    super.key,
    this.onChanged,
    this.hintText,
    required this.controller,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String? labelText, hintText;
  final bool hidden;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final Function(String)? onChanged;

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
        obscureText: isHidden,
        validator: widget.validator ?? (value) {
          if (value!.isEmpty) {
            return 'Field is required';
          }
          return null;
        },
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          suffixIcon: widget.hidden
              ? IconButton(
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
