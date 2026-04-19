import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../home/data/models/product_model.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../order/data/models/cart_item_model.dart';
import '../../../order/domain/repositories/cart_repository.dart';
import '../../../profile/domain/repositories/profile_repository.dart';

class ProductActionBottomSheet extends StatefulWidget {
  final ProductModel product;
  final String actionText;
  final bool isRental;

  const ProductActionBottomSheet({
    super.key,
    required this.product,
    required this.actionText,
    this.isRental = false,
  });

  @override
  State<ProductActionBottomSheet> createState() =>
      _ProductActionBottomSheetState();
}

class _ProductActionBottomSheetState extends State<ProductActionBottomSheet> {
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;
  final CartRepository _cartRepository = CartRepository();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes != null && widget.product.sizes!.isNotEmpty) {
      _selectedSize = widget.product.sizes!.first;
    }
    if (widget.product.colors != null && widget.product.colors!.isNotEmpty) {
      _selectedColor = widget.product.colors!.first;
    }
  }

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

  Future<void> _handleAction() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu.')),
      );
      return;
    }

    // Check Profile Completeness
    final profileRepo = ProfileRepository();
    final profile = await profileRepo.getCurrentProfile();
    
    if (profile == null || 
        profile.fullName == null || profile.fullName!.isEmpty ||
        profile.phoneNumber == null || profile.phoneNumber!.isEmpty ||
        profile.address == null || profile.address!.isEmpty) {
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Profil Belum Lengkap',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Silakan lengkapi Nama Lengkap, Nomor Telepon, dan Alamat Anda sebelum melakukan transaksi.',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Nanti', style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close bottom sheet
                  context.push('/edit-profile');
                },
                child: Text(
                  'Lengkapi Sekarang',
                  style: GoogleFonts.poppins(color: const Color(0xFFFFCC00), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
      return;
    }

    if (widget.product.id == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Produk tidak valid.')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (widget.actionText == 'Masukkan Keranjang') {
        final cartItem = CartItemModel(
          id: '',
          userId: userId,
          productId: widget.product.id!,
          quantity: _quantity,
          variation: [
            if (_selectedSize != null) 'Ukuran: $_selectedSize',
            if (_selectedColor != null) 'Warna: $_selectedColor'
          ].join(', '),
        );

        await _cartRepository.addToCart(cartItem);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berhasil ditambahkan ke keranjang.')),
          );
        }
      } else {
        if (mounted) {
          Navigator.pop(context);
          context.push(
            '/checkout?from=detail',
            extra: {
              'product': widget.product,
              'quantity': _quantity,
              'variation': [
                if (_selectedSize != null) 'Ukuran: $_selectedSize',
                if (_selectedColor != null) 'Warna: $_selectedColor'
              ].join(', '),
              'isRental': widget.isRental,
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.product.imagePath.startsWith('http')
                      ? Image.network(
                          widget.product.imagePath,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
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

            if (widget.product.sizes != null && widget.product.sizes!.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
              ),

              Text(
                'Ukuran',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1B1B1B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.product.sizes!.map((size) {
                  bool isSelected = _selectedSize == size;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSize = size),
                    child: Container(
                      width: 60,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFCC00)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFFCC00)
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        size,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1B1B1B),
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            if (widget.product.colors != null && widget.product.colors!.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
              ),

              Text(
                'Warna',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1B1B1B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.product.colors!.map((colorName) {
                  bool isSelected = _selectedColor == colorName;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = colorName),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFCC00)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFFCC00)
                              : const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        colorName,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1B1B1B),
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

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
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF1B1B1B),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFFCC00),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 20,
                        color: const Color(0xFFE2E8F0),
                      ),
                      _buildQtyBtn(Icons.add, () {
                        // Max allowed is either default maxQty or current stock, whichever is lower
                        int maxAllowed = widget.product.maxQty;
                        if (widget.product.stock < maxAllowed) {
                           maxAllowed = widget.product.stock;
                        }
                        
                        if (_quantity < maxAllowed) {
                          setState(() => _quantity++);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Batas pembelian maksimal adalah $maxAllowed buah'),
                              duration: const Duration(seconds: 2),
                            )
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Action Button
            PrimaryButton(
              text: _isSubmitting ? 'Memproses...' : widget.actionText,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              onPressed: _isSubmitting ? null : _handleAction,
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
