import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/google.png', width: 24, height: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: const Color(0xFF1B1B1B),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
