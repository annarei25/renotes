import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Mensaje que se muestra cuando una lista está vacía o un filtro no
/// devuelve resultados.
///
/// - Normal: ocupa toda la pantalla, centrado y con scroll propio para no
///   desbordar con el teclado abierto.
/// - [compacto]: sin centrado ni scroll, para usarlo dentro de un ListView.
class EmptyState extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String mensaje;
  final String? textoBoton;
  final VoidCallback? onBoton;
  final bool compacto;

  const EmptyState({
    super.key,
    required this.icono,
    required this.titulo,
    required this.mensaje,
    this.textoBoton,
    this.onBoton,
    this.compacto = false,
  });

  @override
  Widget build(BuildContext context) {
    final contenido = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: Icon(icono, size: 32, color: AppColors.textTertiary),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: AppTextStyles.titleMd,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          mensaje,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMd,
        ),
        if (textoBoton != null && onBoton != null) ...[
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton(onPressed: onBoton, child: Text(textoBoton!)),
        ],
      ],
    );

    if (compacto) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl),
        child: contenido,
      );
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: contenido,
      ),
    );
  }
}
