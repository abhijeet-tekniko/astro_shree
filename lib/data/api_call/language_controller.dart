import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  var selectedLanguage = 'en'.obs;
  static const String _languageKey = 'selected_language';

  Future<void> setLanguage(String langCode) async {
    selectedLanguage.value = langCode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, langCode);
  }

  /// Load language from SharedPreferences (called at app start)
  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString(_languageKey);

    if (savedLang != null && savedLang.isNotEmpty) {
      selectedLanguage.value = savedLang;
    }
  }

  String get languageLabel =>
      selectedLanguage.value == 'hi' ? 'Hindi' : 'English';
}
