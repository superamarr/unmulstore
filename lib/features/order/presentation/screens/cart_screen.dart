import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/widgets/confirm_action_sheet.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/models/cart_item_model.dart';
import '../../domain/repositories/cart_repository.dart';

class CartScreen extends StatefulWidget {
  final String? from;
  const CartScreen({super.key, this.from});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartRepository _cartRepository = CartRepository();
  List<CartItemModel> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() => _isLoading = true);
    try {
      final items = await _cartRepository.getCartItems();
      setState(() {
        _cartItems = items.map((item) {
          item.isSelected = false;
          return item;
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  int _calculateTotal() {
    return _cartItems
        .where((item) => item.isSelected)
        .fold<int>(0, (sum, item) => sum + item.totalPrice);
  }

  int _getSelectedCount() {
    return _cartItems.where((item) => item.isSelected).length;
  }

  List<CartItemModel> _getSelectedItems() {
    return _cartItems.where((item) => item.isSelected).toList();
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      for (var item in _cartItems) {
        item.isSelected = value ?? false;
      }
    });
  }

  void _toggleItem(int index) {
    setState(() {
      _cartItems[index].isSelected = !_cartItems[index].isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSelected =
        _cartItems.isNotEmpty && _cartItems.every((item) => item.isSelected);
    final someSelected = _cartItems.any((item) => item.isSelected);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF1B1B1B),
            size: 20,
          ),
          onPressed: () {
            if (widget.from == 'detail') {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Text(
          'Keranjang',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1B1B1B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (_cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: allSelected,
                      tristate: someSelected && !allSelected,
                      onChanged: _toggleSelectAll,
                      activeColor: const Color(0xFFFFCC00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Pilih Semua',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: _cartItems.isEmpty
                      ? Center(
                          child: Text(
                            'Keranjang kosong',
                            style: GoogleFonts.poppins(),
                          ),
                        )
                      : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _cartItems.length,
                          itemBuilder: (context, index) {
                            final item = _cartItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildCartItem(context, item, index),
                            );
                          },
                        ),
                ),
                if (_cartItems.isNotEmpty) _buildBottomBar(context),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemModel item, int index) {
    final product = item.product;
    if (product == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isSelected
              ? const Color(0xFFFFCC00)
              : const Color(0xFFF1F5F9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _toggleItem(index),
            child: Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 30, right: 12),
              decoration: BoxDecoration(
                color: item.isSelected
                    ? const Color(0xFFFFCC00)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isSelected
                      ? const Color(0xFFFFCC00)
                      : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: item.isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.imagePath.startsWith('http')
                ? Image.network(
                    product.imagePath,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    product.imagePath,
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  ),
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
                        product.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: const Color(0xFF1B1B1B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final ok = await showConfirmActionSheet(
                          context,
                          variant: ConfirmActionVariant.removeFromCart,
                        );
                        if (ok != true || !mounted) return;
                        await _cartRepository.removeFromCart(item.id);
                        _loadCart();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xFFCBD5E1),
                      ),
                    ),
                  ],
                ),
                Text(
                  item.variation ?? '',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp${product.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFFCC00),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _cartRepository.updateQuantity(
                                item.id,
                                item.quantity - 1,
                              );
                              _loadCart();
                            },
                            child: _buildQtyBtn(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              item.quantity.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: const Color(0xFF1B1B1B),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await _cartRepository.updateQuantity(
                                item.id,
                                item.quantity + 1,
                              );
                              _loadCart();
                            },
                            child: _buildQtyBtn(Icons.add),
                          ),
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
    final selectedCount = _getSelectedCount();
    final total = _calculateTotal();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
              Text(
                'Total (${selectedCount} item)',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF64748B),
                  fontSize: 15,
                ),
              ),
              Text(
                'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.")}',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF1B1B1B),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: selectedCount > 0
                ? 'Checkout ($selectedCount item)'
                : 'Pilih Item Dulu',
            fontWeight: FontWeight.bold,
            onPressed: selectedCount > 0
                ? () {
                    final selectedItems = _getSelectedItems();
                    context.push(
                      '/checkout?from=${widget.from}',
                      extra: {'items': selectedItems},
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
