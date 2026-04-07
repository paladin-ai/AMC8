/// Shared language code used across all pages and the database `language` column.
/// Supported codes: 'en', 'zh-Hans', 'zh-Hant'
class AppLanguage {
  AppLanguage._();

  static const String english = 'en';
  static const String chineseSimplified = 'zh-Hans';
  static const String chineseTraditional = 'zh-Hant';

  static const List<String> supported = [english, chineseSimplified, chineseTraditional];

  /// Human-readable display name for each language code shown in the UI picker.
  static const Map<String, String> displayNames = {
    english: 'English',
    chineseSimplified: '简体中文',
    chineseTraditional: '繁體中文',
  };

  static String code = english;

  /// Sets [code] only when [lang] is one of [supported]; ignores unknown values.
  static void setCode(String lang) {
    if (supported.contains(lang)) code = lang;
  }

  static bool get isEnglish => code == english;
  static bool get isChineseSimplified => code == chineseSimplified;
  static bool get isChineseTraditional => code == chineseTraditional;
}
