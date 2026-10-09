import 'package:flutter/material.dart';

/// Espaciados (múltiplos de 4 y 8).
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  static const EdgeInsets screenPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
}

/// Radios de borde.
class AppRadius {
  AppRadius._();

  static const double sm = 8; // chips de etiqueta
  static const double md = 12; // botones e inputs
  static const double lg = 16; // tarjetas y FAB
  static const double xl = 20; // diálogos y bottom sheets

  static BorderRadius get tag => BorderRadius.circular(sm);
  static BorderRadius get input => BorderRadius.circular(md);
  static BorderRadius get button => BorderRadius.circular(md);
  static BorderRadius get card => BorderRadius.circular(lg);
  static BorderRadius get dialog => BorderRadius.circular(xl);
}
