import 'package:athar/core/widgets/app_notification.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String _normalizeWhatsAppPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
  if (digits.startsWith('+')) return digits.substring(1);
  if (digits.startsWith('00')) return digits.substring(2);
  if (digits.startsWith('0') && digits.length == 11) {
    return '20${digits.substring(1)}';
  }
  return digits;
}

Future<void> launchWhatsAppMessage({
  required BuildContext context,
  required String message,
  String? phone,
}) async {
  final encodedMessage = Uri.encodeComponent(message);
  final normalizedPhone = phone == null || phone.trim().isEmpty
      ? null
      : _normalizeWhatsAppPhone(phone);

  final appUrl = normalizedPhone == null
      ? 'whatsapp://send?text=$encodedMessage'
      : 'whatsapp://send?phone=$normalizedPhone&text=$encodedMessage';
  final apiUrl = normalizedPhone == null
      ? 'https://api.whatsapp.com/send?text=$encodedMessage'
      : 'https://api.whatsapp.com/send?phone=$normalizedPhone&text=$encodedMessage';
  final waMeUrl = normalizedPhone == null
      ? 'https://wa.me/?text=$encodedMessage'
      : 'https://wa.me/$normalizedPhone?text=$encodedMessage';

  for (final uri in [Uri.parse(appUrl), Uri.parse(apiUrl), Uri.parse(waMeUrl)]) {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (_) {
      // Try the next WhatsApp URL shape.
    }
  }

  if (context.mounted) {
    AppNotification.showError(context, 'تعذر فتح واتساب. تأكد من تثبيت التطبيق أو توفر واتساب ويب.');
  }
}

class WhatsAppLauncher {
  static Future<bool> sendDirectReport({
    required String phone,
    required String message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message);
    final normalizedPhone = _normalizeWhatsAppPhone(phone);
    final appUrl = 'whatsapp://send?phone=$normalizedPhone&text=$encodedMessage';
    final apiUrl = 'https://api.whatsapp.com/send?phone=$normalizedPhone&text=$encodedMessage';
    final waMeUrl = 'https://wa.me/$normalizedPhone?text=$encodedMessage';

    for (final uri in [Uri.parse(appUrl), Uri.parse(apiUrl), Uri.parse(waMeUrl)]) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }
}
