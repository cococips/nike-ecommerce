// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Nike Enterprise';

  @override
  String get homeTitle => 'NIKE';

  @override
  String get homeSubtitle => 'JUST DO IT.';

  @override
  String get noProducts => 'Tidak ada produk tersedia.';

  @override
  String get addToCart => 'Tambah ke Keranjang';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get failedToLoad => 'Gagal memuat produk';
}
