import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _GoogleLogoIcon(),
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

class _GoogleLogoIcon extends StatelessWidget {
  const _GoogleLogoIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Google_Favicon_2025.svg/1280px-Google_Favicon_2025.svg.png',
        width: 24,
        height: 24,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(painter: _GoogleIconPainter());
        },
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = const Color(0xFF4285F4);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 3.5,
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.35),
      size.width / 4.5,
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.65),
      size.width / 4.5,
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.65),
      size.width / 4.5,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
