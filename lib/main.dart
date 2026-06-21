import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization is wrapped in try-catch in case options are not yet configured.
  // We use placeholder logic so the app won't crash before flutterfire configure is run.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase Initialization Error: $e. Did you run flutterfire configure?');
  }

  runApp(const ProviderScope(child: NikeEcommerceApp()));
}

class NikeEcommerceApp extends StatelessWidget {
  const NikeEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nike E-commerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
