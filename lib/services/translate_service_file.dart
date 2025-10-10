
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SmartTranslatableText extends StatelessWidget {
  final TranslatableString translatable;
  final String languageCode;
  final TextStyle? style;
  final TextAlign? textAlign;

  const SmartTranslatableText({
    super.key,
    required this.translatable,
    required this.languageCode,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: translatable.getTranslation(languageCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('...', style: style);
        } else if (snapshot.hasError) {
          return Text(translatable.original, style: style);
        } else {
          return Text(snapshot.data ?? translatable.original,
              style: style, textAlign: textAlign);
        }
      },
    );
  }
}



///


class TranslatableString {
  final String original;
  final Map<String, String> _translations = {};

  TranslatableString(this.original);

  static const String _apiKey = 'AIzaSyBR9LulNitqW7OiaEk4xX3SxKImkvuyDKw';

  Future<String> getTranslation(String targetLanguage) async {
    if (targetLanguage == 'en') {
      return original;
    }

    if (_translations.containsKey(targetLanguage)) {
      return _translations[targetLanguage]!;
    }

    final translated = await _translateText(original, targetLanguage);
    _translations[targetLanguage] = translated;
    return translated;
  }

  static Future<String> _translateText(String text, String targetLanguage) async {
    final url = Uri.parse(
      'https://translation.googleapis.com/language/translate/v2?key=$_apiKey',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'q': text,
        'target': targetLanguage,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['data']['translations'][0]['translatedText'];
    } else {
      throw Exception('Translation failed: ${response.body}');
    }
  }
}
