import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/confirm_action_sheet.dart';

class MonitoringDendaScreen extends StatefulWidget {
  const MonitoringDendaScreen({super.key});

  @override
  State<MonitoringDendaScreen> createState() => _MonitoringDendaScreenState();
}

class _MonitoringDendaScreenState extends State<MonitoringDendaScreen> {
  final AdminRepository _repo = AdminRepository();
  List<Map<String, dynamic>> _denda = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDenda();
  }

  Future<void> _loadDenda() async {
    try {
      final denda = await _repo.getDenda();
      if (mounted) {
        setState(() {
          _denda = denda;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _validasiDenda(String orderId, int denda) async {
    final ok = await showConfirmActionSheet(
      context,
      variant: ConfirmActionVariant.custom,
      title: 'Validasi denda?',
      message:
          'Apakah Anda yakin ingin memvalidasi denda sebesar Rp ${denda.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} untuk pesanan ini?',
      confirmLabel: 'Validasi',
      icon: Icons.fact_check_rounded,
      iconBackgroundColor: const Color(0xFFE0F2FE),
      iconColor: const Color(0xFF0284C7),
      confirmBackgroundColor: const Color(0xFF0284C7),
    );
    if (ok != true || !mounted) return;

    try {
      await _repo.validasiDenda(orderId, denda);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Denda berhasil divalidasi')),
        );
        _loadDenda();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Monitoring Denda',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B1B1B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _denda.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada keterlambatan',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _denda.length,
              itemBuilder: (context, index) {
                final item = _denda[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order #${item['id'].toString().substring(0, 8)}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Terlambat ${item['hari_terlambat']} hari',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Durasi: ${item['duration'] ?? 7} hari',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Denda: Rp ${item['denda'] ?? 0}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              _validasiDenda(item['id'], item['denda'] ?? 0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: Text(
                            'Validasi Denda',
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
