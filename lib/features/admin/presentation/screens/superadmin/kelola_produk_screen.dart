import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pab/features/home/data/models/product_model.dart';
import 'package:pab/features/admin/domain/repositories/superadmin_repository.dart';
import 'package:pab/core/theme/app_theme.dart';
import 'package:pab/shared/widgets/confirm_action_sheet.dart';

class KelolaProdukScreen extends StatefulWidget {
  const KelolaProdukScreen({super.key});

  @override
  State<KelolaProdukScreen> createState() => _KelolaProdukScreenState();
}

class _KelolaProdukScreenState extends State<KelolaProdukScreen> {
  final SuperAdminRepository _repo = SuperAdminRepository();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await _repo.getAllProducts();
    if (mounted) {
      setState(() {
        _products = products;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(String id) async {
    final confirm = await showConfirmActionSheet(
      context,
      variant: ConfirmActionVariant.delete,
      title: 'Hapus produk?',
      message:
          'Apakah Anda yakin ingin menghapus produk ini secara permanen? Aksi ini tidak dapat dibatalkan.',
    );

    if (confirm == true) {
      try {
        await _repo.deleteProduct(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil dihapus')),
          );
          _loadProducts();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  String _formatPrice(dynamic price) {
    var str = price.toString();
    var result = '';
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) result += '.';
      result += str[str.length - 1 - i];
    }
    return 'Rp${result.split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          context.push('/superadmin-tambah-produk').then((value) {
            if (value == true) {
              _loadProducts(); // refresh catalog when coming back
            }
          });
        },
        icon: const Icon(Icons.add, color: Colors.black),
        label: Text(
          'Tambah Produk',
          style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: _products.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada produk di etalase.',
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                     final product = _products[index];
                     final isRentable = product['is_rentable'] == true;

                     return Container(
                       margin: const EdgeInsets.only(bottom: 16),
                       padding: const EdgeInsets.all(12),
                       decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(16),
                         border: Border.all(color: const Color(0xFFE2E8F0)),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black.withValues(alpha: 0.02),
                             blurRadius: 10,
                             offset: const Offset(0, 4),
                           )
                         ]
                       ),
                       child: Row(
                         children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(12),
                             child: product['image_path'] != null && product['image_path'].toString().startsWith('http')
                               ? Image.network(
                                   product['image_path'],
                                   width: 65,
                                   height: 65,
                                   fit: BoxFit.cover,
                                   errorBuilder: (_,__,___) => _buildPlaceholder(),
                                 )
                               : _buildPlaceholder(),
                           ),
                           const SizedBox(width: 16),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   product['title'] ?? 'Produk Tanpa Nama',
                                   style: GoogleFonts.poppins(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 14,
                                     color: const Color(0xFF1B1B1B),
                                   ),
                                   maxLines: 1,
                                   overflow: TextOverflow.ellipsis,
                                 ),
                                 const SizedBox(height: 4),
                                 Row(
                                   children: [
                                     Text(
                                       _formatPrice(product['price'] ?? 0),
                                       style: GoogleFonts.poppins(
                                         fontWeight: FontWeight.bold,
                                         fontSize: 13,
                                         color: const Color(0xFFFFCC00),
                                       ),
                                     ),
                                     const SizedBox(width: 8),
                                     Container(
                                       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                       decoration: BoxDecoration(
                                         color: isRentable ? Colors.green.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                                         borderRadius: BorderRadius.circular(4),
                                       ),
                                       child: Text(
                                         isRentable ? 'SEWA' : 'BELI',
                                         style: GoogleFonts.poppins(
                                           fontSize: 9,
                                           fontWeight: FontWeight.bold,
                                           color: isRentable ? Colors.green.shade700 : Colors.blue.shade700,
                                         ),
                                       ),
                                     )
                                   ],
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   'Stok: ${product['stock'] ?? 0}',
                                   style: GoogleFonts.poppins(
                                     fontSize: 11,
                                     color: const Color(0xFF64748B),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           Row(
                             mainAxisSize: MainAxisSize.min,
                             children: [
                               IconButton(
                                 onPressed: () {
                                   try {
                                     // Konversi data mentah dari Supabase ke objek ProductModel
                                     final rawData = Map<String, dynamic>.from(product);
                                     final productModel = ProductModel.fromMap(rawData);
                                     
                                     debugPrint('Navigating to edit: ${productModel.title}');
                                     
                                     // Kirim objek ke halaman edit
                                     context.push('/superadmin-tambah-produk', extra: productModel).then((value) {
                                       if (value == true) {
                                         _loadProducts();
                                       }
                                     });
                                   } catch(e) {
                                     debugPrint('Error parsing product: $e');
                                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                       content: Text('Gagal memuat data produk: $e'),
                                       backgroundColor: Colors.red,
                                     ));
                                   }
                                 },
                                 icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                               ),
                               IconButton(
                                 onPressed: () => _deleteProduct(product['id']),
                                 icon: const Icon(Icons.delete_outline, color: Colors.red),
                               ),
                             ],
                           ),
                         ],
                       ),
                     );
                  },
                ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 65,
      height: 65,
      color: const Color(0xFFF1F5F9),
      child: const Icon(Icons.image_not_supported, color: Color(0xFF94A3B8)),
    );
  }
}
