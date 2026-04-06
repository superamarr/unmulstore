import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import 'home_screen.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  // List layar yang akan ditampilkan (hanya index 0 yang kita develop saat ini)
  final List<Widget> _screens = [
    const HomeScreen(),
    const SizedBox.shrink(), // Index 1 is now handled by push navigation
    const Scaffold(body: Center(child: Text('Pesanan'))),
    const Scaffold(body: Center(child: Text('Profil'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // IndexedStack maintains state of each screen
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          
          // Floating Bottom Navigation (Glassmorphism)
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(0, Icons.home_outlined, 'Beranda', svgPath: 'assets/icons/beranda.svg'),
                      _buildNavItem(1, Icons.shopping_cart_outlined, '', svgPath: 'assets/icons/keranjang.svg'),
                      _buildNavItem(2, Icons.message_outlined, 'Pesanan', svgPath: 'assets/icons/ikonpesan.svg'),
                      _buildNavItem(3, Icons.person_outline, ''),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData fallbackIcon, String label, {String? svgPath}) {
    bool isSelected = _currentIndex == index;
    
    if (isSelected && label.isNotEmpty) {
      if (index == 0 && svgPath != null) {
        // Ikon Beranda adalah SVG komposit (sudah ada background kuning + teks)
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SvgPicture.asset(
            svgPath,
            height: 40,
            fit: BoxFit.contain,
          ),
        );
      }
      
      // Fallback Pill Kuning untuk menu lain jika terpilih
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            svgPath != null
                ? SvgPicture.asset(svgPath, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 24, height: 24)
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
    
    // Icon biasa (Keranjang, Profil dll)
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          context.push('/cart?from=home');
        } else if (index == 2) {
          context.push('/order-history');
        } else {
          setState(() => _currentIndex = index);
        }
      },
      child: Container(
        color: Colors.transparent, // expand tap area
        padding: const EdgeInsets.all(12),
        child: svgPath != null
            ? SvgPicture.asset(svgPath, 
                colorFilter: ColorFilter.mode(isSelected ? AppTheme.primaryColor : const Color(0xFF1B4D30), BlendMode.srcIn), 
                width: 28, height: 28)
            : Icon(
                fallbackIcon,
                color: isSelected ? AppTheme.primaryColor : const Color(0xFF1B4D30),
                size: 28,
              ),
      ),
    );
  }
}
