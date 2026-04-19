import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/svg_assets.dart';
import 'home_screen.dart';
import '../../../order/presentation/screens/order_history_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  // List layar yang akan ditampilkan
  List<Widget> get _screens => [
    const HomeScreen(),
    const SizedBox.shrink(), // Index 1 handled by navigation
    OrderHistoryScreen(
      isTab: true,
      onBack: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
    const Scaffold(body: Center(child: Text('Profil'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),

          // Floating Bottom Navigation (Glassmorphism)
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                0,
                Icons.home_outlined,
                'Beranda',
                svgPath: 'assets/icons/ikonhome.svg',
              ),
              _buildNavItem(
                1,
                Icons.shopping_cart_outlined,
                '',
                svgPath: 'assets/icons/keranjang.svg',
              ),
              _buildNavItem(
                2,
                Icons.content_paste_outlined,
                'Pesanan',
                svgPath: 'assets/icons/ikonpesan.svg',
              ),
              _buildNavItem(
                3,
                Icons.person_outline,
                '',
                svgPath: 'assets/icons/user.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData fallbackIcon,
    String label, {
    String? svgPath,
  }) {
    bool isSelected = _currentIndex == index;

    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            svgPath != null
                ? SvgPicture.asset(
                    svgPath,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    width: 24,
                    height: 24,
                  )
                : Icon(fallbackIcon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          context.push('/cart?from=home');
        } else {
          setState(() => _currentIndex = index);
        }
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(12),
        child: (index == 0)
            ? SvgPicture.asset(
                'assets/icons/ikonhome.svg',
                colorFilter: const ColorFilter.mode(
                  Color(0xFF1B4D30),
                  BlendMode.srcIn,
                ),
                width: 28,
                height: 28,
              )
            : (index == 2)
                ? SvgPicture.asset(
                    'assets/icons/ikonpesan.svg',
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF1B4D30),
                      BlendMode.srcIn,
                    ),
                    width: 28,
                    height: 28,
                  )
                : (svgPath != null
                    ? SvgPicture.asset(
                        svgPath,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1B4D30),
                          BlendMode.srcIn,
                        ),
                        width: 28,
                        height: 28,
                      )
                    : Icon(
                        fallbackIcon,
                        color: const Color(0xFF1B4D30),
                        size: 28,
                      )),
      ),
    );
  }
}
