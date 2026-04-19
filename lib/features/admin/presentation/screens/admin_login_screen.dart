import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/theme/app_theme.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInput);
    _passwordController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final adminRepo = AdminRepository();
    try {
      final admin = await adminRepo.adminLogin(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (mounted && admin != null) {
        debugPrint(
          'Login successful for: ${admin.email} with role: ${admin.role}',
        );
        context.go('/admin-dashboard', extra: {'role': admin.role});
      } else if (mounted) {
        debugPrint(
          'Login failed: admin is null - wrong credentials or not admin',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email, password salah, atau bukan akun admin'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (mounted) {
        String message = 'Login gagal';
        if (e.toString().contains('Invalid login') ||
            e.toString().contains('400')) {
          message = 'Email atau password salah';
        } else if (e.toString().contains('null') ||
            e.toString().contains('timeout')) {
          message =
              'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        } else if (e.toString().contains('network')) {
          message = 'Tidak dapat terhubung ke server';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              const SizedBox(height: 40),
              Text(
                'Admin Login',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1B1B1B),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan email dan password admin',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF4B4B4B),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _emailController,
                hintText: 'Masukkan email',
                prefixIcon: const Icon(Icons.email, color: Color(0xFFCBD5E1)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Masukkan password',
                prefixIcon: const Icon(Icons.lock, color: Color(0xFFCBD5E1)),
                obscureText: true,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Masuk',
                isDisabled: !_isButtonEnabled,
                isLoading: _isLoading,
                onPressed: _onLogin,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Center(
                  child: GestureDetector(
                    onTap: () => context.go('/'),
                    child: Text(
                      'Kembali ke halaman utama',
                      style: GoogleFonts.poppins(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
