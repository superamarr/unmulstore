import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/primary_button.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1B1B1B), size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Status Pesanan',
          style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Section
            _buildTimelineSection(),
            
            const SizedBox(height: 32),
            
            // Order Detail Card
            _buildOrderDetailCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Column(
      children: [
        _buildTimelineItem(
          'Menunggu Verifikasi', 
          '24 Maret, 2026 - 09:41', 
          isCompleted: true, 
          isLast: false,
          icon: Icons.check,
        ),
        _buildTimelineItem(
          'Disetujui', 
          '24 Maret, 2026 - 10:41', 
          isCompleted: true, 
          isLast: false,
          icon: Icons.check,
        ),
        _buildTimelineItem(
          'Dikirim', 
          'Kurir sedang dalam perjalanan ke lokasi anda', 
          isCompleted: true, 
          isLast: false,
          icon: Icons.local_shipping_outlined,
          description: 'Perkiraan: Hari Ini',
          isYellowDescription: true,
        ),
        _buildTimelineItem(
          'Selesai', 
          'Tunggu hingga paket Anda tiba.', 
          isCompleted: false, 
          isLast: true,
          icon: Icons.check,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(
    String title, 
    String subtitle, {
    required bool isCompleted, 
    required bool isLast,
    required IconData icon,
    String? description,
    bool isYellowDescription = false,
  }) {
    final Color activeColor = const Color(0xFF00BFA5); // Teal Green
    final Color inactiveColor = const Color(0xFFF1F5F9);
    final Color textColor = isCompleted ? const Color(0xFF1B1B1B) : const Color(0xFF94A3B8);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left portion: Icon and Line
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isCompleted ? activeColor : inactiveColor,
                  shape: BoxShape.circle,
                  boxShadow: isCompleted ? [
                    BoxShadow(color: activeColor.withOpacity(0.2), blurRadius: 10, spreadRadius: 2)
                  ] : null,
                ),
                child: Icon(icon, color: isCompleted ? Colors.white : const Color(0xFFCBD5E1), size: 22),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isCompleted ? activeColor.withOpacity(0.3) : const Color(0xFFF1F5F9),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),
          // Right portion: Texts
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, 
                      fontSize: 15, 
                      color: textColor
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12, 
                      color: const Color(0xFF94A3B8),
                      height: 1.4
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isYellowDescription ? const Color(0xFFFFCC00) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetailCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: [
          // Order Header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset('assets/images/workshirt.jpeg', width: 70, height: 70, fit: BoxFit.cover),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'T-shirt Universitas Mulawarm..',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Size: XL - Qty 1',
                      style: GoogleFonts.poppins(color: const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp100.000',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: _DottedDivider(),
          ),
          
          _buildDetailRow('Biaya Pengiriman', 'Rp 0'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jumlah Pembayaran', 
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black)
              ),
              Text(
                'Rp100.000', 
                style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 16, color: const Color(0xFFFFCC00))
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Hubungin Kurir Button
          PrimaryButton(
            text: 'Hubungin Kurir',
            fontWeight: FontWeight.w900,
            onPressed: () {},
            prefixIcon: Icons.phone,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label, 
          style: GoogleFonts.poppins(color: const Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w600)
        ),
        Text(
          value, 
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black)
        ),
      ],
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double boxWidth = constraints.constrainWidth();
        const double dashWidth = 3.0;
        const double dashSpace = 4.0;
        final int dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFFE2E8F0)),
              ),
            );
          }),
        );
      },
    );
  }
}
