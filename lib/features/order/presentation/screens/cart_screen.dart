import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/primary_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1B1B)),
          onPressed: () {
            final from = GoRouterState.of(context).uri.queryParameters['from'];
            if (from == 'detail') {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Keranjang',
          style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCartItem(
                  context,
                  'Official WorkShirt Mul..',
                  'Ukuran, L',
                  100000,
                  'assets/images/workshirt.jpeg',
                ),
                const SizedBox(height: 16),
                _buildCartItem(
                  context,
                  'Toga Wisuda Unmul',
                  'Ukuran, XL',
                  275000,
                  'assets/images/toga.png',
                ),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, String title, String subtitle, int price, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, width: 85, height: 85, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title, 
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1B1B1B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.close, size: 18, color: Color(0xFFCBD5E1)),
                  ],
                ),
                Text(subtitle, style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}',
                      style: GoogleFonts.poppins(color: const Color(0xFFFFCC00), fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          _buildQtyBtn(Icons.remove),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('1', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1B1B1B))),
                          ),
                          _buildQtyBtn(Icons.add),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Icon(icon, size: 14, color: const Color(0xFF64748B)),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Jumlah Total', style: GoogleFonts.poppins(color: const Color(0xFF64748B), fontSize: 15)),
              Text(
                'Rp 350.000', 
                style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Checkout',
            fontWeight: FontWeight.bold,
            onPressed: () => context.push('/checkout'),
          ),
        ],
      ),
    );
  }
}
