import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
///This is my personal class boiler plate for TextFormField decorations
///This will be used for  decorations formFields
///
///
class CustomTextBox extends StatelessWidget {
  InputDecoration inputDecoration;
  final TextInputType textInputType;
  final String hintText;
  final TextEditingController editTextController;
  final Key key;
  final int minLines, maxLines;
  final FormFieldValidator validator;
  final Function handle;
  final bool suffixBtn;
  IconData suffixIcon;
  bool obscureText = false;
  CustomTextBox({
    this.key,
    this.inputDecoration,
    this.textInputType,
    this.hintText,
    this.editTextController,
    this.minLines = 1,
    this.maxLines = 1,
    this.validator,
    this.handle,
    this.suffixBtn = false,
    this.obscureText = false,
    this.suffixIcon = Icons.visibility_off,
  }) : super(key: key) {
    if (this.inputDecoration == null) {
      this.inputDecoration = InputDecoration(
        suffixIcon: this.suffixBtn
            ? IconButton(
                onPressed: () => this.handle(),
                icon: Icon(this.suffixIcon),
              )
            : SizedBox(
                height: 0,
              ),
        // hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: Colors.grey,
        ),
        filled: true,
        fillColor: Colors.white,

        labelText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black),
        ),
        errorStyle: TextStyle(
          fontSize: 16.0,
          color: Colors.redAccent,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        labelStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText : this.obscureText,
      style: TextStyle(
          color: Colors.black, fontSize: 19, fontWeight: FontWeight.normal),
      minLines: this.minLines,
      validator: this.validator,
      maxLines: this.maxLines,
      controller: editTextController,
      decoration: inputDecoration,
      keyboardType: textInputType,
    );
  }
}
