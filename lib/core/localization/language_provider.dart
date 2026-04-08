import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _languagePrefsKey = 'selected_language';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedCode = prefs.getString(_languagePrefsKey);
    if (savedCode != null) {
      return Locale(savedCode);
    }
    // Default to English
    return const Locale('en');
  }

  Future<void> changeLanguage(String languageCode) async {
    if (state.languageCode == languageCode) return;
    
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_languagePrefsKey, languageCode);
    state = Locale(languageCode);
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});
