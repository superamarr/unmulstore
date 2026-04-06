import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
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
        style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
