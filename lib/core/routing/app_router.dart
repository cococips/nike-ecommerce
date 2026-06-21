import 'package:go_router/go_router.dart';
import 'package:nike_ecommerce/features/splash/presentation/splash_screen.dart';
import 'package:nike_ecommerce/features/products/presentation/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
