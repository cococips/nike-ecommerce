import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/features/auth/presentation/providers/auth_providers.dart';
import 'package:nike_ecommerce/features/auth/presentation/screens/login_screen.dart';
import 'package:nike_ecommerce/features/auth/presentation/screens/register_screen.dart';
import 'package:nike_ecommerce/features/splash/presentation/splash_screen.dart';
import 'package:nike_ecommerce/features/main/presentation/main_screen.dart';
import 'package:nike_ecommerce/features/admin/presentation/screens/settings_screen.dart';
import 'package:nike_ecommerce/features/admin/presentation/screens/admin_products_screen.dart';
import 'package:nike_ecommerce/features/admin/presentation/screens/add_edit_product_screen.dart';
import 'package:nike_ecommerce/features/products/domain/models/product.dart';
import 'package:nike_ecommerce/features/products/presentation/screens/product_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      final isAuth = authState.value != null;
      final isSplash = state.matchedLocation == '/';
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (isSplash) {
        // Let the splash screen handle its own delay, it will navigate to /home or /login
        return null;
      }

      if (!isAuth && !isLoggingIn) {
        return '/login';
      }

      if (isAuth && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminProductsScreen(),
      ),
      GoRoute(
        path: '/admin/add-edit',
        builder: (context, state) {
          final product = state.extra as Product?;
          return AddEditProductScreen(product: product);
        },
      ),
      GoRoute(
        path: '/product-detail',
        builder: (context, state) {
          final product = state.extra as Product;
          return ProductDetailScreen(product: product);
        },
      ),
    ],
  );
});
