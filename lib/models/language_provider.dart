// lib/models/language_provider.dart
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('en'); // Default language is English

  Locale get currentLocale => _currentLocale;

  void toggleLanguage() {
    if (_currentLocale.languageCode == 'en') {
      _currentLocale = const Locale('am'); // Switch to Amharic
    } else {
      _currentLocale = const Locale('en'); // Switch back to English
    }
    notifyListeners(); // Tells the whole app to rebuild with the new language
  }
}