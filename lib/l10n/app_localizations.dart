// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;


  // Update this line to accept either a Locale or a String locale name
  AppLocalizations(dynamic locale)
      : locale = locale is Locale ? locale : Locale(locale.toString());

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }



  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Your verified ARB translation maps mapped directly into Dart
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'perfumeDescription': 'Blur gender boundaries and be unconventionally free with this flowery-vanilla eau de parfum.',
      'addToBasket': 'ADD TO BASKET',
      'orderHistory': 'Order History',
      'noOrdersYet': 'You have not placed any orders yet.\nStart exploring our luxury perfumes!',
      'close': 'Close',
    },
    'am': {
      'perfumeDescription': 'የጾታ ድንበሮችን በማደብዘዝ እና በዚህ የአበባ-ቫኒላ ኦ ደ ፓርፉም ያልተለመደ ነፃነት ይኑሩ።',
      'addToBasket': 'ወደ ቅርጫት አስገባ',
      'orderHistory': 'የትዕዛዝ ታሪክ',
      'noOrdersYet': 'እስካሁን ምንም ትዕዛዝ አልፈጸሙም።\nየእኛን የቅንጦት ሽቶዎች መመርመር ይጀምሩ!',
      'close': 'ዝጋ',
    },
  };

  String get perfumeDescription => _localizedValues[locale.languageCode]?['perfumeDescription'] ?? '';
  String get addToBasket => _localizedValues[locale.languageCode]?['addToBasket'] ?? '';
  String get orderHistory => _localizedValues[locale.languageCode]?['orderHistory'] ?? '';
  String get noOrdersYet => _localizedValues[locale.languageCode]?['noOrdersYet'] ?? '';
  String get close => _localizedValues[locale.languageCode]?['close'] ?? '';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'am'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}