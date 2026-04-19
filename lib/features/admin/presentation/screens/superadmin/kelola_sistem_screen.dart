import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pab/features/admin/domain/repositories/superadmin_repository.dart';
import 'package:pab/core/theme/app_theme.dart';
import 'package:pab/shared/widgets/primary_button.dart';
import 'package:pab/shared/widgets/confirm_action_sheet.dart';

class KelolaSistemScreen extends StatefulWidget {
  const KelolaSistemScreen({super.key});

  @override
  State<KelolaSistemScreen> createState() => _KelolaSistemScreenState();
}

class _KelolaSistemScreenState extends State<KelolaSistemScreen> {
  final SuperAdminRepository _repo = SuperAdminRepository();
  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _lateFeeCtrl = TextEditingController();
  final TextEditingController _depositCtrl = TextEditingController();
  final TextEditingController _rentalDurationCtrl = TextEditingController();

  Map<String, dynamic> _settings = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final settings = await _repo.getGlobalSettings();
    if (mounted) {
      setState(() {
        _settings = settings;
        _lateFeeCtrl.text = _settings['late_fee_per_day']?.toString() ?? '20000';
        _depositCtrl.text = _settings['default_deposit']?.toString() ?? '50000';
        _rentalDurationCtrl.text = _settings['default_rental_duration']?.toString() ?? '3';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    final lateFeeText = _lateFeeCtrl.text.trim();
    final depositText = _depositCtrl.text.trim();
    final durationText = _rentalDurationCtrl.text.trim();

    if (lateFeeText.isEmpty || depositText.isEmpty || durationText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi!')),
      );
      return;
    }

    final lateFee = num.tryParse(lateFeeText);
    final deposit = num.tryParse(depositText);
    final duration = num.tryParse(durationText);

    if (lateFee == null || deposit == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pastikan semua input berupa angka!')),
      );
      return;
    }

    final confirm = await showConfirmActionSheet(
      context,
      variant: ConfirmActionVariant.save,
      title: 'Simpan pengaturan sistem?',
      message:
          'Apakah Anda yakin ingin menerapkan nilai denda, deposit, dan durasi sewa ke seluruh sistem?',
    );
    if (confirm != true || !mounted) return;

    setState(() => _isSaving = true);
    try {
      await _repo.updateGlobalSetting('late_fee_per_day', lateFee);
      await _repo.updateGlobalSetting('default_deposit', deposit);
      await _repo.updateGlobalSetting('default_rental_duration', duration);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengaturan berhasil disimpan!')),
        );
        // Reload settings agar UI sinkron dengan database
        await _loadSettings();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _lateFeeCtrl.dispose();
    _depositCtrl.dispose();
    _rentalDurationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Konfigurasi Global',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF1B1B1B),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nilai default yang akan digunakan oleh sistem transaksi.',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  _buildSettingCard(
                    title: 'Denda Keterlambatan (Late Fee)',
                    subtitle: 'Denda per hari keterlambatan',
                    controller: _lateFeeCtrl,
                    icon: Icons.money_off,
                    keyboardType: TextInputType.number,
                    prefixText: 'Rp ',
                  ),
                  const SizedBox(height: 16),
                  
                  _buildSettingCard(
                    title: 'Biaya Jaminan (Deposit)',
                    subtitle: 'Deposit standar untuk penyewaan',
                    controller: _depositCtrl,
                    icon: Icons.security,
                    keyboardType: TextInputType.number,
                    prefixText: 'Rp ',
                  ),
                  const SizedBox(height: 16),

                  _buildSettingCard(
                    title: 'Batas Masa Sewa (Hari)',
                    subtitle: 'Waktu maksimal peminjaman produk',
                    controller: _rentalDurationCtrl,
                    icon: Icons.timer,
                    keyboardType: TextInputType.number,
                    suffixText: ' Hari',
                  ),
                  
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Simpan Pengaturan',
                    isLoading: _isSaving,
                    onPressed: _saveSettings,
                  ),
                ],
              ),
            );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    String? prefixText,
    String? suffixText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFF1B1B1B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF1B1B1B),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              prefixText: prefixText,
              suffixText: suffixText,
              prefixStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
              suffixStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
