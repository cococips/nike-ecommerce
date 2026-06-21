import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// TODO: Import file Splash Screen nanti
// import 'features/splash/presentation/pages/splash_page.dart'; 

void main() async {
  // Wajib dipanggil sebelum inisialisasi binding apapun di Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase berdasarkan platform (Android/iOS/Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // TODO: Inisialisasi Dependency Injection (GetIt) di sini nanti
  // await di.init();

  runApp(const NikeApp());
}

class NikeApp extends StatelessWidget {
  const NikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nike Enterprise Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema minimalis hitam-putih khas Nike
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: Colors.grey,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      // Untuk sementara kita arahkan ke halaman kosong berlatar hitam
      // Nanti akan diganti menjadi SplashPage()
      home: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ), 
    );
  }
}