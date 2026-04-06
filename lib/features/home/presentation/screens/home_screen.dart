import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/product_model.dart';
import '../widgets/product_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bunga Logo (using image or icon)
                    Container(
                      width: 40,
                      height: 40,
                      child: Image.asset('assets/icons/Logo.png', fit: BoxFit.contain), 
                    ),
                    
                    // Lokasi Title
                    Column(
                      children: [
                        Text('Lokasi Store', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.subtitleColor, fontSize: 10)),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.red, size: 16),
                            const SizedBox(width: 4),
                            Text('Universitas Mulawarman', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.textColor, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                    
                    // Notifikasi
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.borderColor),
                      ),
                      child: const Icon(Icons.notifications_none, color: AppTheme.textColor),
                    ),
                  ],
                ),
              ),
            ),
            
            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Produk',
                      hintStyle: const TextStyle(color: AppTheme.subtitleColor),
                      prefixIcon: const Icon(Icons.search, color: AppTheme.textColor),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ),
            
            // Promo Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/promo.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: AppTheme.primaryColor,
                      child: const Center(child: Text('PROMO BANNER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ),
            ),
            
            // Product Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75, // Aspect ratio agar gambar lebih dominan (tinggi > lebar)
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ProductCardWidget(product: dummyProducts[index]);
                  },
                  childCount: dummyProducts.length,
                ),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Spacing agar tidak tertutup bottom nav
            ),
          ],
        ),
      ),
    );
  }
}
