import 'package:flutter/material.dart';

class InputCustomizado extends StatelessWidget {
  InputCustomizado(
      {required this.controller,
      required this.hint,
      this.obscure = false,
      this.autofocus = false,
      this.type = TextInputType.text});

  TextEditingController controller;
  String hint;
  bool obscure;
  bool autofocus;
  TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.type,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6))),
    );
  }
}
