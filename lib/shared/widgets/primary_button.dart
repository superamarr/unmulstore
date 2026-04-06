import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final IconData? prefixIcon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isDisabled = false,
    this.fontWeight,
    this.fontSize,
    this.textColor,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? const Color(0xFFE2E8F0) : AppTheme.primaryColor,
          foregroundColor: isDisabled ? const Color(0xFF8E929A) : (textColor ?? AppTheme.textColor),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Matching design better
          ),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: fontWeight ?? FontWeight.w700, 
                fontSize: fontSize ?? 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
