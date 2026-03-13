import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // ==================== PRIMARY COLORS ====================

  static const Color primary = Color(0xFF000B2E7);

  static const Color primaryDark = Color(0xFF27AE60);

  static const Color primaryLight = Color(0xFF58D68D);

  // ==================== SECONDARY COLORS ====================

  static const Color secondary = Color(0xFFE064F7);

  static const Color secondaryDark = Color(0xFF2980B9);


  // ==================== TERTIARY COLORS ====================
// 

  static const Color tertiary = Color(0xFFFF8D6C);

  // ==================== ACCENT COLORS ====================

  static const Color accent = Color(0xFFE74C3C);

  static const Color error = Color(0xFFE74C3C);

  static const Color warning = Color(0xFFF39C12);

  static const Color success = Color(0xFF2ECC71);

  // ==================== NEUTRAL COLORS ====================

  static const Color background = Color(0xFFF8F9FA);

  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2C3E50);

  static const Color textSecondary = Color(0xFF7F8C8D);

  static const Color divider = Color(0xFFECF0F1);

  static const Color disabled = Color(0xFF95A5A6);

  // ==================== CATEGORY COLORS ====================

  static const Color makanan = Color(0xFFE67E22);

  static const Color transport = Color(0xFF3498DB);

  static const Color belanja = Color(0xFFE91E63);

  static const Color hiburan = Color(0xFF9B59B6);

  static const Color kesehatan = Color(0xFF1ABC9C);

  static const Color lainnya = Color(0xFF95A5A6);

  // ==================== CATEGORY COLOR MAP ====================

  static const Map<String, Color> categoryColors = {
    'Makanan': makanan,
    'Transport': transport,
    'Belanja': belanja,
    'Hiburan': hiburan,
    'Kesehatan': kesehatan,
    'Lainnya': lainnya,
  };

  // ==================== HELPER METHODS ====================

  static Color getCategoryColor(String category) {
    return categoryColors[category] ?? lainnya;
  }

  static Color getCategoryColorLight(String category) {
    return getCategoryColor(category).withOpacity(0.2);
  }

  static List<String> get allCategories => categoryColors.keys.toList();

  static bool isCategoryValid(String category) {
    return categoryColors.containsKey(category);
  }
}
