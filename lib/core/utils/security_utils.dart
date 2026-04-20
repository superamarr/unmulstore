import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SecurityUtils {
  static final _htmlPattern = RegExp(
    r'<[^>]*>|&lt;|&gt;|&amp;|&quot;|&#39;|&#x27;|&#x2F;|&#47;|&nbsp;',
    caseSensitive: false,
  );

  static final _scriptPattern = RegExp(
    r'<script[^>]*>.*?</script>|<iframe[^>]*>.*?</iframe>|<object[^>]*>.*?</object>|<embed[^>]*>',
    caseSensitive: false,
    dotAll: true,
  );

  static final _urlPattern = RegExp(
    r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    caseSensitive: false,
  );

  static final _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    caseSensitive: false,
  );

  static final _phonePattern = RegExp(
    r'^[0-9+\-\s()]{6,20}$',
  );

  static final _numericPattern = RegExp(r'^[0-9]+$');

  static final _alphanumericPattern = RegExp(r'^[a-zA-Z0-9\s]+$');

  static String sanitizeInput(String input) {
    if (input.isEmpty) return '';
    
    String sanitized = input.trim();
    
    sanitized = sanitized.replaceAll('<', '&lt;');
    sanitized = sanitized.replaceAll('>', '&gt;');
    sanitized = sanitized.replaceAll('"', '&quot;');
    sanitized = sanitized.replaceAll("'", '&#39;');
    sanitized = sanitized.replaceAll('/', '&#47;');
    
    return sanitized;
  }

  static String stripHtml(String input) {
    if (input.isEmpty) return '';
    return input.replaceAll(_htmlPattern, '');
  }

  static String preventXSS(String input) {
    if (input.isEmpty) return '';
    
    String sanitized = input;
    
    sanitized = _scriptPattern.allMatches(sanitized).map((m) => '').join('');
    
    sanitized = sanitizeInput(sanitized);
    
    return sanitized;
  }

  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    return _urlPattern.hasMatch(url);
  }

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return _emailPattern.hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    return _phonePattern.hasMatch(phone);
  }

  static bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return _numericPattern.hasMatch(value);
  }

  static bool isAlphanumeric(String value) {
    if (value.isEmpty) return false;
    return _alphanumericPattern.hasMatch(value);
  }

  static int parseSafeInt(String input, {int defaultValue = 0}) {
    if (input.isEmpty) return defaultValue;
    final parsed = int.tryParse(input);
    return parsed ?? defaultValue;
  }

  static double parseSafeDouble(String input, {double defaultValue = 0.0}) {
    if (input.isEmpty) return defaultValue;
    final cleaned = input.replaceAll(',', '.').replaceAll(' ', '');
    final parsed = double.tryParse(cleaned);
    return parsed ?? defaultValue;
  }

  static String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String truncateText(String input, int maxLength, {String ellipsis = '...'}) {
    if (input.isEmpty) return '';
    if (input.length <= maxLength) return input;
    return '${input.substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  static String maskEmail(String email) {
    if (!isValidEmail(email)) return email;
    
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) return email;
    
    final masked = '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}@$domain';
    return masked;
  }

  static String maskPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    if (cleaned.length < 4) return phone;
    
    final visible = cleaned.substring(cleaned.length - 4);
    return '****$visible';
  }

  static bool containsSQLInjection(String input) {
    final lower = input.toLowerCase();
    final sqlKeywords = [
      'select ', 'from ', 'where ', 'insert ', 'update ', 'delete ',
      'drop ', 'create ', 'alter ', 'union ', 'join ',
      '--', ';--', '/*', '*/', 'xp_', 'sp_',
      'exec(', 'execute(', 'eval(',
    ];
    
    for (final keyword in sqlKeywords) {
      if (lower.contains(keyword)) return true;
    }
    
    return false;
  }

  static List<String> validateProductInput({
    required String title,
    required String description,
    required String price,
    required String stock,
    required String maxQty,
    String? sizes,
    String? colors,
  }) {
    final errors = <String>[];
    
    if (title.isEmpty) {
      errors.add('Nama produk wajib diisi');
    } else if (containsSQLInjection(title)) {
      errors.add('Nama produk mengandung karakter tidak aman');
    } else if (title.length > 100) {
      errors.add('Nama produk maksimal 100 karakter');
    }
    
    if (description.isEmpty) {
      errors.add('Deskripsi produk wajib diisi');
    } else if (containsSQLInjection(description)) {
      errors.add('Deskripsi mengandung karakter tidak aman');
    } else if (description.length > 1000) {
      errors.add('Deskripsi maksimal 1000 karakter');
    }
    
    if (!isNumeric(price) || parseSafeInt(price) <= 0) {
      errors.add('Harga wajib diisi dan lebih dari 0');
    }
    
    if (!isNumeric(stock) || parseSafeInt(stock) < 0) {
      errors.add('Stok wajib diisi');
    }
    
    if (!isNumeric(maxQty) || parseSafeInt(maxQty) <= 0) {
      errors.add('Maksimal pembelian wajib diisi dan lebih dari 0');
    }
    
    if (sizes != null && sizes.isNotEmpty && containsSQLInjection(sizes)) {
      errors.add('Ukuran mengandung karakter tidak aman');
    }
    
    if (colors != null && colors.isNotEmpty && containsSQLInjection(colors)) {
      errors.add('Warna mengandung karakter tidak aman');
    }
    
    return errors;
  }
}

class SafeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool escapeHtml;

  const SafeText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.escapeHtml = true,
  });

  @override
  Widget build(BuildContext context) {
    final safeText = escapeHtml ? SecurityUtils.stripHtml(text) : text;
    
    return Text(
      safeText,
      style: style ?? GoogleFonts.poppins(fontSize: 14),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}