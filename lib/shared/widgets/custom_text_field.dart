import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        style: GoogleFonts.poppins(
          color: const Color(0xFF1B1B1B),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFF94A3B8),
            fontSize: 14,
          ),
          counterText: '', // Hide default character counter 
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
