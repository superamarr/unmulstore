import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.textColor,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
