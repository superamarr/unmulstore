import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1B1B1B), size: 20),
            onPressed: () => context.go('/home'),
          ),
          title: Text(
            'Pesanan',
            style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          bottom: TabBar(
            indicatorColor: const Color(0xFFFFCC00),
            indicatorWeight: 3,
            labelColor: const Color(0xFFFFCC00),
            unselectedLabelColor: const Color(0xFF94A3B8),
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: const [
              Tab(text: 'Pembelian'),
              Tab(text: 'Penyewaan'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(context),
            const Center(child: Text('Belum ada penyewaan')),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildOrderCard(
          context,
          orderId: 'ORD-88291',
          date: '19 Maret 2026',
          status: 'Selesai',
          statusColor: const Color(0xFFD1FAE5),
          statusTextColor: const Color(0xFF10B981),
          productTitle: 'T-shirt Universitas Mulawarm..',
          variation: 'Ukuran: L',
          price: 100000,
          imagePath: 'assets/images/workshirt.jpeg',
          actionButtons: [
            _buildActionBtn('Beli Lagi', isPrimary: true),
            _buildActionBtn('Detail', isPrimary: false, onTap: () => context.push('/order-status')),
          ],
        ),
        const SizedBox(height: 16),
        _buildOrderCard(
          context,
          orderId: 'ORD-88291',
          date: '20 Maret 2026',
          status: 'Diproses',
          statusColor: const Color(0xFFDBEAFE),
          statusTextColor: const Color(0xFF3B82F6),
          productTitle: 'Toga Wisuda Unmul',
          variation: 'Ukuran: L',
          price: 275000,
          imagePath: 'assets/images/toga.png',
          actionButtons: [
            _buildActionBtn('Lacak', isPrimary: true),
            _buildActionBtn('Detail', isPrimary: false, onTap: () => context.push('/order-status')),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required String orderId,
    required String date,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String productTitle,
    required String variation,
    required int price,
    required String imagePath,
    required List<Widget> actionButtons,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header: Order ID & Status
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: Color(0xFFFFCC00), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$orderId • $date',
                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.poppins(color: statusTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Product Info
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(imagePath, width: 64, height: 64, fit: BoxFit.cover),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productTitle,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$variation • 1 Qty',
                      style: GoogleFonts.poppins(color: const Color(0xFF334155), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actionButtons,
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(String text, {required bool isPrimary, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isPrimary ? const Color(0xFFFFCC00) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isPrimary ? const Color(0xFFFFCC00) : const Color(0xFF1B1B1B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
