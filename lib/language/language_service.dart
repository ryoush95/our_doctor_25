import 'en.dart';
import 'ko.dart';

class LanguageService {
  static Map<String, String> languageMap = new Map();

  static setLanguage(String lang) {
    if (lang == 'ko') {
      languageMap = ko_lang;
    } else {
      languageMap = en_lang;
    }
  }

  static String trans(String key) {
    return languageMap[key] ?? key;
  }
}
