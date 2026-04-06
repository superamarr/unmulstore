import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/home'),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Alamat Pengiriman'),
            _buildAddressCard(),
            _buildSectionHeader('Produk'),
            _buildProductCard(),
            _buildSectionHeader('Metode Pembayaran', trailing: _buildCashOnlyBadge()),
            _buildPaymentMethods(),
            _buildSectionHeader('Rincian Pembayaran'),
            _buildPaymentDetails(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title, 
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black)
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildCashOnlyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'CASH ONLY',
        style: GoogleFonts.poppins(color: const Color(0xFFEF4444), fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFFFCC00), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
                          children: [
                            const TextSpan(text: 'Budi Santoso', style: TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: '   | (+62) 812-3456-7890', style: TextStyle(color: const Color(0xFF475569), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Edit', 
                      style: GoogleFonts.poppins(color: const Color(0xFFFFCC00), fontWeight: FontWeight.bold, fontSize: 14)
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Jl. Mulawarman No. 1, Gn. Kelua, Kec. Samarinda Ulu, Kota Samarinda, Kalimantan Timur 75123',
                  style: GoogleFonts.poppins(color: const Color(0xFF334155), fontSize: 12, height: 1.6, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset('assets/images/workshirt.jpeg', width: 75, height: 75, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Official WorkShirt Mul..', 
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1B1B1B))
                ),
                Text('Ukuran, L', style: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  'Rp100.000', 
                  style: GoogleFonts.poppins(color: const Color(0xFFFFCC00), fontWeight: FontWeight.bold, fontSize: 16)
                ),
              ],
            ),
          ),
          Text(
            '1x', 
            style: GoogleFonts.poppins(color: const Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        _buildPaymentOption(0, 'COD (Cash on Delivery)', 'Bayar tunai saat barang tiba.', Icons.payments_outlined),
        const SizedBox(height: 12),
        _buildPaymentOption(1, 'Bayar di Toko', 'Ambil dan bayar di UNMUL STORE', Icons.storefront_outlined),
      ],
    );
  }

  Widget _buildPaymentOption(int index, String title, String sub, IconData icon) {
    bool isSelected = _selectedPaymentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFCC00) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFCC00) : const Color(0xFFCBD5E1),
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, 
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1B1B1B))
                  ),
                  Text(
                    sub, 
                    style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 12)
                  ),
                ],
              ),
            ),
            Icon(icon, color: const Color(0xFFCBD5E1), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildDetailRow('Harga Produk', 'Rp 100.000'),
          const SizedBox(height: 12),
          _buildDetailRow('Biaya Pengiriman', 'Rp 0'),
          const SizedBox(height: 16),
          _buildDashedLine(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price', 
                style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14)
              ),
              Text(
                'Rp 100.000', 
                style: GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black)
              ),
            ],
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
          style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 14, fontWeight: FontWeight.w500)
        ),
        Text(
          value, 
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF1B1B1B))
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(40, (index) {
        return Expanded(
          child: Container(
            height: 1,
            color: index % 2 == 0 ? const Color(0xFFE2E8F0) : Colors.transparent,
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      decoration: const BoxDecoration(
        color: Color(0xFFFFCC00),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pesanan Berhasil Dibuat!')),
            );
            context.go('/home');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'BAYAR SEKARANG', 
                style: GoogleFonts.poppins(
                  fontSize: 12, 
                  fontWeight: FontWeight.w600, 
                  color: const Color(0xFF1B1B1B), 
                  letterSpacing: 1.5
                )
              ),
              Text(
                'Rp.100.000', 
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, 
                  fontSize: 24, 
                  color: const Color(0xFF1B1B1B)
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

