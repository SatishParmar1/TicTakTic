import 'package:flutter/material.dart';
import 'LanguageTranslation.dart';

class TranslationsDelegate extends LocalizationsDelegate<LanguageTranslation> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => [
    "en",
    "hi",
    "gu",
    "mr",
  ].contains(locale.languageCode);

  @override
  Future<LanguageTranslation> load(Locale locale) =>
      LanguageTranslation.load(locale);

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}
