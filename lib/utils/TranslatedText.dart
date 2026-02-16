import 'package:flutter/material.dart';
import 'language/LanguageTranslation.dart';

class TranslatedText extends StatelessWidget {
  final String? textKey;
  final InlineSpan? richText;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextDirection? textDirection;
  final bool? softWrap;
  final double? textScaleFactor;
  final StrutStyle? strutStyle;
  final Locale? locale;

  /// Constructor for normal text
  const TranslatedText(
      this.textKey, {
        super.key,
        this.style,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.textDirection,
        this.softWrap,
        this.textScaleFactor,
        this.strutStyle,
        this.locale,
      }) : richText = null;

  /// Named constructor for rich text
  const TranslatedText.rich(
      this.richText, {
        super.key,
        this.style,
        this.textAlign,
        this.overflow,
        this.maxLines,
        this.textDirection,
        this.softWrap,
        this.textScaleFactor,
        this.strutStyle,
        this.locale,
      }) : textKey = null;

  InlineSpan _translateSpan(BuildContext context, InlineSpan span) {
    if (span is TextSpan) {
      return TextSpan(
        text: span.text != null
            ? LanguageTranslation.of(context)?.value(span.text!) ?? span.text
            : null,
        style: span.style,
        children: span.children?.map((child) => _translateSpan(context, child)).toList(),
        recognizer: span.recognizer,
      );
    }
    return span;
  }

  @override
  Widget build(BuildContext context) {
    if (richText != null) {
      return Text.rich(
        _translateSpan(context, richText!),
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textDirection: textDirection,
        softWrap: softWrap,
        textScaleFactor: textScaleFactor,
        strutStyle: strutStyle,
        locale: locale,
      );
    } else {
      String translatedText = LanguageTranslation.of(context)?.value(textKey!) ?? textKey!;
      return Text(
        translatedText,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textDirection: textDirection,
        softWrap: softWrap,
        textScaleFactor: textScaleFactor,
        strutStyle: strutStyle,
        locale: locale,
      );
    }
  }
}