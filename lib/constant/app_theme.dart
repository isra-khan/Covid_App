import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A237E);
  static const Color primaryLight = Color(0xFF534BAE);
  static const Color accent = Color(0xFF00BFA5);
  static const Color background = Color(0xFFF5F7FB);
  static const Color cardBg = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color critical = Color(0xFFDC2626);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A237E), Color(0xFF3949AB), Color(0xFF5C6BC0)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB91C1C), Color(0xFFEF4444)],
  );
}

class NumberFormatter {
  static String compact(num n) {
    final v = n.abs();
    if (v >= 1e9) return '${(n / 1e9).toStringAsFixed(2)}B';
    if (v >= 1e6) return '${(n / 1e6).toStringAsFixed(2)}M';
    if (v >= 1e3) return '${(n / 1e3).toStringAsFixed(1)}K';
    return n.toString();
  }

  static String withCommas(num n) {
    final s = n.toString();
    final buffer = StringBuffer();
    final parts = s.split('.');
    final intPart = parts[0];
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    if (parts.length > 1) buffer.write('.${parts[1]}');
    return buffer.toString();
  }
}
