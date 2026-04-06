import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/data/models/product_model.dart';
import '../widgets/product_action_bottom_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Helper Format Price
  String _formatPrice(int price) {
    var str = price.toString();
    var result = '';
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result += '.';
      result += str[i];
    }
    return 'Rp $result';
  }

  void _showBottomSheet(BuildContext context, String actionText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductActionBottomSheet(
        product: widget.product,
        actionText: actionText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Container
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Image.asset(
                    widget.product.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Product Metadata
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price
                      Text(
                        _formatPrice(widget.product.price),
                        style: GoogleFonts.poppins(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title
                      Text(
                        widget.product.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: const Color(0xFF1B1B1B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description
                      Text(
                        widget.product.description,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF4B4B4B),
                          height: 1.5,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Warna Selector Preview
                      Text(
                        'Warna',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF1B1B1B)),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.product.imagePath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Ukuran Selector Preview
                      Text(
                        'Ukuran',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF1B1B1B)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: ['S', 'M', 'L', 'XL'].map((size) {
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            width: 60,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(size, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: const Color(0xFF1B1B1B))),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      
                      // Expandables
                      const Divider(color: Color(0xFFE2E8F0)),
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text('Panduan Ukuran', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B))),
                          tilePadding: EdgeInsets.zero,
                          children: [
                            Text('Deskripsi ukuran standar mulai dari S hingga XL.', style: GoogleFonts.poppins(color: const Color(0xFF4B4B4B))),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFFE2E8F0)),
                      Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text('Deskripsi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1B1B1B))),
                          tilePadding: EdgeInsets.zero,
                          children: [
                            Text(widget.product.description, style: GoogleFonts.poppins(color: const Color(0xFF4B4B4B))),
                          ],
                        ),
                      ),
                      const Divider(color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 100), // spacing for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context, 'Masukkan Keranjang'),
                      child: Container(
                        height: 80,
                        color: const Color(0xFF47413E), // Dark matching design
                        child: Center(
                          child: SvgPicture.asset('assets/icons/keranjang.svg', width: 24, height: 24),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: GestureDetector(
                      onTap: () => _showBottomSheet(context, 'Beli Sekarang'),
                      child: Container(
                        height: 80,
                        color: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center, // Centered text to match image better
                          children: [
                            Text(
                              'TOTAL BAYAR', 
                              style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontWeight: FontWeight.w600, fontSize: 13, letterSpacing: 1.2)
                            ),
                            Text(
                              _formatPrice(widget.product.price),
                              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 24, color: const Color(0xFF1B1B1B)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header Floating Buttons (SVG Header) - Placed last to be on very top
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/Header.svg', 
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          
          // Transparent clickable areas on top of Header SVG for navigation
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(width: 70, height: 60, color: Colors.transparent),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push('/cart?from=detail'),
                  child: Container(width: 70, height: 60, color: Colors.transparent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
