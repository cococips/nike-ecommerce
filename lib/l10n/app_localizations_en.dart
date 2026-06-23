// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nike Enterprise';

  @override
  String get homeTitle => 'NIKE';

  @override
  String get homeSubtitle => 'JUST DO IT.';

  @override
  String get noProducts => 'No products available.';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get retry => 'Retry';

  @override
  String get failedToLoad => 'Failed to load products';
}
