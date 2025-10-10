import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchInBrowser(String url) async {
    final uri = _toUri(url);
    if (uri == null) return;
    await _launch(uri, mode: LaunchMode.externalApplication);
  }

  /// Launch a URL inside the app (in-app browser/webview)
  static Future<void> launchInApp(String url) async {
    final uri = _toUri(url);
    if (uri == null) return;
    await _launch(uri, mode: LaunchMode.inAppWebView);
  }

  /// Launch a phone call using tel:
  static Future<void> launchPhone(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    await _launch(uri);
  }

  /// Launch an SMS using sms:
  static Future<void> launchSMS(String phoneNumber, {String? message}) async {
    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      query: message != null ? 'body=${Uri.encodeComponent(message)}' : null,
    );
    await _launch(uri);
  }

  /// Launch WhatsApp with optional pre-filled message
  static Future<void> launchWhatsApp(
    String phoneNumber, {
    String? message,
  }) async {
    final formatted = phoneNumber.replaceAll(
      RegExp(r'\D'),
      '',
    ); // Remove non-digits
    final msg = message != null ? Uri.encodeComponent(message) : '';
    final uri = Uri.parse(
      "https://wa.me/$formatted${msg.isNotEmpty ? "?text=$msg" : ""}",
    );
    await _launch(uri, mode: LaunchMode.externalApplication);
  }

  /// Launch an email using mailto:
  static Future<void> launchEmail({
    required String toEmail,
    String? subject,
    String? body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: _encodeQueryParameters(<String, String>{
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      }),
    );
    await _launch(uri);
  }

  /// Convert a string to a Uri, with error handling
  static Uri? _toUri(String url) {
    try {
      return Uri.parse(url);
    } catch (e) {
      debugPrint("Invalid URL: $url");
      return null;
    }
  }

  /// Centralized launcher method with error logging
  static Future<void> _launch(
    Uri uri, {
    LaunchMode mode = LaunchMode.platformDefault,
  }) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    } else {
      debugPrint("Could not launch: $uri");
    }
  }

  /// Helper to encode mailto query parameters
  static String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }
}
