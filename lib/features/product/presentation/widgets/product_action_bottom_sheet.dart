import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../home/data/models/product_model.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';

class ProductActionBottomSheet extends StatefulWidget {
  final ProductModel product;
  final String actionText; // "Masukkan Keranjang" or "Beli Sekarang"

  const ProductActionBottomSheet({
    super.key,
    required this.product,
    required this.actionText,
  });

  @override
  State<ProductActionBottomSheet> createState() => _ProductActionBottomSheetState();
}

class _ProductActionBottomSheetState extends State<ProductActionBottomSheet> {
  int _quantity = 1;

  // Helper Format Price
  String _formatPrice(int price) {
    var str = price.toString();
    var result = '';
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result += '.';
      result += str[i];
    }
    return 'Rp$result'; 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Thumbnail, Title, Price, Stock
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    widget.product.imagePath,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, 
                          fontSize: 14,
                          color: const Color(0xFF1B1B1B),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(widget.product.price),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFFFCC00), 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Stok: ${widget.product.stock}',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1B1B1B), 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
            ),
            
            Text(
              'Ukuran', 
              style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['S', 'M', 'L', 'XL'].map((size) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 60,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    size, 
                    style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
            ),
            
            Text(
              'Warna', 
              style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['Hijau', 'Hitam'].map((colorName) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    colorName, 
                    style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
            ),
            
            // Modifier Jumlah
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah', 
                  style: GoogleFonts.poppins(color: const Color(0xFF1B1B1B), fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () {
                        if (_quantity > 1) setState(() => _quantity--);
                      }),
                      Container(
                        width: 1,
                        height: 20,
                        color: const Color(0xFFE2E8F0),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _quantity.toString(), 
                          style: GoogleFonts.poppins(color: const Color(0xFFFFCC00), fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: const Color(0xFFE2E8F0),
                      ),
                      _buildQtyBtn(Icons.add, () {
                        setState(() => _quantity++);
                      }),
                    ],
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Action Button
            PrimaryButton(
              text: widget.actionText,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              onPressed: () {
                Navigator.pop(context); // Close bottom sheet
                if (widget.actionText == 'Beli Sekarang') {
                  context.push('/checkout');
                } else {
                  context.push('/cart?from=detail');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Icon(icon, size: 18, color: const Color(0xFF64748B)),
      ),
    );
  }
}
