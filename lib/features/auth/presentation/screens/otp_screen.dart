import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../widgets/otp_input_field.dart';
import '../../../../core/theme/app_theme.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Masuk menggunakan nomor HP',
                style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  text: 'Masukkan kode yang kami kirimkan melalui\nSMS ke ',
                  style: GoogleFonts.poppins(color: const Color(0xFF4B4B4B), fontSize: 14),
                  children: [
                    TextSpan(
                      text: phoneNumber,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'OTP Code',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B1B1B),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              OtpInputField(
                length: 6,
                onCompleted: (otp) {
                  // TODO: Verify OTP
                  context.go('/home'); // Routing to Home when OTP is finished
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Resend code in 00:50',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
