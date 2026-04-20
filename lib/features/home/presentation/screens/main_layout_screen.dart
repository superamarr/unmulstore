import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/deferred_navigation.dart';
import 'home_screen.dart';
import 'package:pab/features/order/presentation/screens/order_history_screen.dart';
import 'package:pab/features/profile/presentation/screens/profile_screen.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class NavItem {
  final String label;
  final IconData icon;

  NavItem({required this.label, required this.icon});
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkAdminGuard();
  }

  // BENTENG TERAKHIR: Paksa admin pindah ke dashboard jika nyasar ke page user
  Future<void> _checkAdminGuard() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    // Cek Role di berbagai tempat
    String? role = user.userMetadata?['role'] as String?;
    if (role == null || role == 'authenticated') {
      if (user.role != null && user.role != 'authenticated') {
        role = user.role;
      }
    }

    // Jika metadata & user.role masih belum yakin, cek database
    if (role == null || role == 'authenticated') {
      try {
        final profile = await Supabase.instance.client
            .from('profiles')
            .select() // Ambil semua kolom yang ada saja
            .eq('id', user.id)
            .single();
        role = profile['role'];
      } catch (_) {}
    }

    final lowRole = role?.toLowerCase().trim();
    if (lowRole == 'admin' || lowRole == 'superadmin') {
      if (mounted) {
        debugPrint('Admin detected in user page, redirecting to dashboard...');
        await goDeferred(context, '/admin-dashboard', extra: {'role': lowRole});
      }
    }
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const SizedBox.shrink(), // Cart placeholder
    const OrderHistoryScreen(showNavBar: true),
    const ProfileScreen(),
  ];

  final List<NavItem> _navItems = [
    NavItem(label: 'Beranda', icon: Icons.home),
    NavItem(label: 'Keranjang', icon: Icons.shopping_cart),
    NavItem(label: 'Pesanan', icon: Icons.receipt_long),
    NavItem(label: 'Saya', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Screen layer
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: IndexedStack(
              key: ValueKey<int>(_currentIndex),
              index: _currentIndex.clamp(0, _screens.length - 1),
              children: _screens,
            ),
          ),

          // Final Robust Navbar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_navItems.length, (index) {
                      final bool isActive = _currentIndex == index;
                      final bool isCart = index == 1;
                      final item = _navItems[index];

                      return GestureDetector(
                        onTap: () {
                          if (isCart) {
                            context.push('/cart?from=home');
                          } else {
                            setState(() => _currentIndex = index);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: 48,
                          padding: EdgeInsets.symmetric(
                            horizontal: (isActive && !isCart) ? 20 : 12,
                          ),
                          decoration: BoxDecoration(
                            color: isActive && !isCart
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.icon,
                                  size: 24,
                                  color: isActive && !isCart
                                      ? Colors.white
                                      : (isActive && isCart
                                          ? AppTheme.primaryColor
                                          : const Color(0xFF1B4D30)),
                                ),
                                if (isActive && !isCart) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
