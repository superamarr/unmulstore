import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/social_button.dart';
import '../widgets/phone_input_field.dart';
import '../../../../core/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isButtonEnabled = false;

  void _validateInput() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty && _phoneController.text.length >= 8;
    });
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInput);
    _phoneController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Buat Akunmu',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF1B1B1B), 
                        fontWeight: FontWeight.bold, 
                        fontSize: 22
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mulai jelajahi dan pesan produk Unmul Store\nsecara online.',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF4B4B4B), 
                        fontSize: 14
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Nama', 
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B), fontSize: 14)
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _nameController,
                      hintText: 'Masukin nama lengkap',
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFCBD5E1)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Nomor HP', 
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B), fontSize: 14)
                    ),
                    const SizedBox(height: 8),
                    PhoneInputField(controller: _phoneController),
                    
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppTheme.borderColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or login with', 
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, color: const Color(0xFF94A3B8))
                          ),
                        ),
                        const Expanded(child: Divider(color: AppTheme.borderColor)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SocialButton(
                      text: 'Continue With Google',
                      onPressed: () {},
                    ),
                    
                    const Spacer(),
                    
                    const SizedBox(height: 48),
                    PrimaryButton(
                      text: 'Lanjutkan',
                      isDisabled: !_isButtonEnabled,
                      onPressed: () {
                         context.push('/otp', extra: '+62${_phoneController.text}');
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'By entering my phone number, I accept ',
                          style: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 11),
                          children: [
                            TextSpan(
                              text: "Unmul Store's terms of service\n",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B)),
                            ),
                            TextSpan(text: 'and ', style: GoogleFonts.poppins(color: const Color(0xFF94A3B8))),
                            TextSpan(
                              text: 'the personal data processing policy.',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B)),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
