import 'package:flutter/material.dart';

/// Par de colores (fondo + texto) para una etiqueta.
class TagColors {
  final Color bg;
  final Color text;

  const TagColors({required this.bg, required this.text});
}

class AppColors {
  AppColors._();

  // Marca
  static const Color primary = Color(0xFF1E293B); // Slate 800
  static const Color primaryLight = Color(0xFF334155); // Slate 700
  static const Color secondary = Color(0xFF0284C7); // Sky 600
  static const Color accent = Color(0xFFF59E0B); // Amber 500

  // Superficies
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color border = Color(0xFFE2E8F0); // Slate 200

  // Texto
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textTertiary = Color(0xFF94A3B8); // Slate 400

  // Estados
  static const Color error = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFFFBEB);

  // Paleta de etiquetas (8 colores)
  static const List<TagColors> tagPalette = [
    TagColors(bg: Color(0xFFD1FAE5), text: Color(0xFF047857)), // Esmeralda
    TagColors(bg: Color(0xFFE0F2FE), text: Color(0xFF0369A1)), // Azul
    TagColors(bg: Color(0xFFEDE9FE), text: Color(0xFF6D28D9)), // Púrpura
    TagColors(bg: Color(0xFFFEF3C7), text: Color(0xFFB45309)), // Ámbar
    TagColors(bg: Color(0xFFFCE7F3), text: Color(0xFFBE185D)), // Rosa
    TagColors(bg: Color(0xFFCCFBF1), text: Color(0xFF0F766E)), // Turquesa
    TagColors(bg: Color(0xFFE0E7FF), text: Color(0xFF4338CA)), // Índigo
    TagColors(bg: Color(0xFFE2E8F0), text: Color(0xFF334155)), // Pizarra
  ];

  /// Color por defecto cuando la etiqueta no tiene color (Pizarra).
  static const TagColors tagDefault = TagColors(
    bg: Color(0xFFE2E8F0),
    text: Color(0xFF334155),
  );

  /// Devuelve los colores de una etiqueta. Si [index] es null o
  /// no es válido, usa el color por defecto.
  static TagColors tagColors(int? index) {
    if (index == null || index < 0 || index >= tagPalette.length) {
      return tagDefault;
    }
    return tagPalette[index];
  }
}
