import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hallbooking/widgets/colors.dart';

class TextFormInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPass;
  final String hintText;
  final String? labelText;
  final IconData? IconSuffix;
  final IconData? preFixICon;
  final TextInputType textInputType;

  const TextFormInputField(
      {Key? key,
      required this.controller,
      this.isPass = false,
      this.IconSuffix,
      this.labelText,
      this.preFixICon,
      required this.hintText,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 60,
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: Icon(
            IconSuffix,
            color: textformColor,
          ),
          fillColor: textformFillColor,
          hintText: hintText,
          hintStyle: GoogleFonts.nunitoSans(fontSize: 16),
          border: InputBorder.none,
          filled: true,
          contentPadding: EdgeInsets.all(8),
        ),
        keyboardType: textInputType,
        controller: controller,
        obscureText: isPass,
      ),
    );
  }
}
