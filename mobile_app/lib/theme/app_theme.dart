import 'package:flutter/material.dart';

class AppTheme {
  // 宣纸底色（传统水墨画风格）
  static const Color paperWhite = Color(0xFFF8F5F0); // 宣纸白
  static const Color paperCream = Color(0xFFF5F0E8); // 宣纸米黄
  static const Color paperBeige = Color(0xFFEDE8DC); // 宣纸浅黄
  static const Color primaryBlack = Color(0xFFF8F5F0); // 主背景色=宣纸色
  static const Color secondaryBlack = Color(0xFFF5F0E8); // 次背景色

  // 墨色系（从浓到淡）
  static const Color inkBlack = Color(0xFF2C2C2C); // 浓墨
  static const Color inkDark = Color(0xFF4A4A4A); // 重墨
  static const Color inkGray = Color(0xFF6B6B6B); // 中墨
  static const Color inkLight = Color(0xFF9A9A9A); // 淡墨
  static const Color inkFaint = Color(0xFFC8C8C8); // 飞白

  // 强调色（用于文字和图标）
  static const Color accentWhite = Color(0xFF2C2C2C); // 主文字色=浓墨
  static const Color accentRed = Color(0xFF8B4513); // 印章红
  static const Color accentGold = Color(0xFFD4AF37); // 金箔色

  // 辅助色
  static const Color subtleGray = Color(0xFFEDE8DC);
  static const Color lightGray = Color(0xFFC8C8C8);

  // 渐变色彩
  static const LinearGradient inkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [inkBlack, inkDark, inkGray],
  );

  static const LinearGradient paperGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [paperWhite, paperCream, paperBeige],
  );

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light, // 改为亮色主题
      scaffoldBackgroundColor: primaryBlack,

      // 颜色方案 - 宣纸风格
      colorScheme: const ColorScheme.light(
        primary: inkBlack, // 主色=浓墨
        secondary: inkGray, // 次色=中墨
        surface: paperWhite, // 表面=宣纸白
        onSurface: inkBlack, // 表面上的文字=浓墨
        onPrimary: paperWhite, // 主色上的文字=宣纸白
        onSecondary: paperWhite, // 次色上的文字=宣纸白
        surfaceTint: paperCream, // 表面色调
      ),

      // 应用栏主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: accentWhite,
          fontSize: 18,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: accentWhite),
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        color: secondaryBlack,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        margin: const EdgeInsets.all(8),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentWhite,
          foregroundColor: primaryBlack,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // 文本主题
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: accentWhite,
          fontSize: 32,
          fontWeight: FontWeight.w200,
          letterSpacing: 1.0,
        ),
        displayMedium: TextStyle(
          color: accentWhite,
          fontSize: 28,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.8,
        ),
        headlineLarge: TextStyle(
          color: accentWhite,
          fontSize: 24,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.6,
        ),
        headlineMedium: TextStyle(
          color: accentWhite,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        bodyLarge: TextStyle(
          color: accentWhite,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
        bodyMedium: TextStyle(
          color: inkLight,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        bodySmall: TextStyle(
          color: inkLight,
          fontSize: 12,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.1,
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBlack,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: subtleGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: subtleGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: accentWhite, width: 1),
        ),
        labelStyle: const TextStyle(color: inkLight),
        hintStyle: const TextStyle(color: lightGray),
      ),
    );
  }
}
