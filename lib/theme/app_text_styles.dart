import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Estilos de texto. Títulos y etiquetas usan Plus Jakarta Sans;
/// el texto de lectura usa Inter. `height` = altura de línea / tamaño.
class AppTextStyles {
  AppTextStyles._();

  static const String _titulos = 'PlusJakartaSans';
  static const String _lectura = 'Inter';

  // Encabezados
  static const TextStyle headlineLg = TextStyle(
    fontFamily: _titulos,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 32 / 26,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: _titulos,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 28 / 22,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: _titulos,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 26 / 20,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  // Títulos
  static const TextStyle titleLg = TextStyle(
    fontFamily: _titulos,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: _titulos,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColors.textPrimary,
  );

  // Cuerpo
  static const TextStyle bodyLg = TextStyle(
    fontFamily: _lectura,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 26 / 16,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: _lectura,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 21 / 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: _lectura,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 17 / 12,
    color: AppColors.textTertiary,
  );

  // Etiquetas y botones
  static const TextStyle labelLg = TextStyle(
    fontFamily: _titulos,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 20 / 15,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: _titulos,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 18 / 14,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: _titulos,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 14 / 12,
  );

  static const TextStyle labelXs = TextStyle(
    fontFamily: _titulos,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 13 / 11,
    letterSpacing: 0.2,
  );
}
