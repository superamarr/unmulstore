import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../widgets/phone_input_field.dart';
import '../../../../core/theme/app_theme.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _promoController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      setState(() {
        _isButtonEnabled = _phoneController.text.length >= 8;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _promoController.dispose();
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
                'Masuk menggunakan nomor HP',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Mohon konfirmasi kode negara ponsel Anda\ndan masukkan nomor telepon anda',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              PhoneInputField(controller: _phoneController),
              const SizedBox(height: 16),
              TextField(
                controller: _promoController,
                decoration: InputDecoration(
                  hintText: 'Your promo code (Optional)',
                  hintStyle: const TextStyle(color: AppTheme.subtitleColor),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Lanjutkan',
                isDisabled: !_isButtonEnabled,
                onPressed: () {
                  context.push('/otp', extra: '+62${_phoneController.text}');
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By entering my phone number, I accept ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.subtitleColor),
                      children: const [
                        TextSpan(
                          text: "Unmul Store's terms of service\n",
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                        ),
                        TextSpan(text: 'and '),
                        TextSpan(
                          text: 'the personal data processing policy.',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textColor),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
