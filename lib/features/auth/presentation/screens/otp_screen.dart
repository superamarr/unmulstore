import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/otp_input_field.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/repositories/auth_repository.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthRepository _authRepository = AuthRepository();
  int _remainingSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                'Verifikasi OTP',
                style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan kode yang dikirim ke ${widget.phoneNumber}',
                style: GoogleFonts.poppins(color: const Color(0xFF4B4B4B), fontSize: 14),
              ),
              const SizedBox(height: 32),
              OtpInputField(
                length: 6,
                onCompleted: (otp) async {
                  try {
                    await _authRepository.verifyOtp(widget.phoneNumber, otp);
                    if (mounted) context.go('/home');
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Verifikasi gagal: $e')),
                      );
                    }
                  }
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: _remainingSeconds > 0
                    ? Text(
                        'Resend code in 00:${_remainingSeconds.toString().padLeft(2, '0')}',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF94A3B8),
                            fontSize: 13),
                      )
                    : GestureDetector(
                        onTap: () {
                          // TODO: Implement Resend Logic
                          setState(() {
                            _remainingSeconds = 60;
                            _startTimer();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Kode dikirim ulang!')),
                          );
                        },
                        child: Text(
                          'Kirim Ulang Kode',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                              fontSize: 13,
                              decoration: TextDecoration.underline),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
