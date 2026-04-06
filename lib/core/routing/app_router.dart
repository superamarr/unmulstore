import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/phone_login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/home/presentation/screens/main_layout_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/home/data/models/product_model.dart';
import '../../features/order/presentation/screens/cart_screen.dart';
import '../../features/order/presentation/screens/checkout_screen.dart';
import '../../features/order/presentation/screens/order_status_screen.dart';
import '../../features/order/presentation/screens/order_history_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainLayoutScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/phone-login',
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          // Extra to pass the phone number from previous screen
          final phoneNumber = state.extra as String? ?? 'Unknown Number';
          return OtpScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-status',
        builder: (context, state) => const OrderStatusScreen(),
      ),
      GoRoute(
        path: '/order-history',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
    ],
  );
}
