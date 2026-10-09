import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import 'tag_chip.dart';

/// Fila horizontal de chips para filtrar por una o varias etiquetas.
/// El primer chip ("Todas") quita el filtro.
class TagFilterBar extends StatelessWidget {
  final List<Etiqueta> etiquetas;
  final Set<String> seleccionadas;
  final int? totalNotas; // número que se muestra junto a "Todas" (opcional)
  final int Function(String etiquetaId)? cantidadDe; // conteo por etiqueta
  final ValueChanged<String> onAlternar;
  final VoidCallback onLimpiar;
  final EdgeInsetsGeometry padding; // margen horizontal de la fila

  const TagFilterBar({
    super.key,
    required this.etiquetas,
    required this.seleccionadas,
    this.totalNotas,
    this.cantidadDe,
    required this.onAlternar,
    required this.onLimpiar,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: etiquetas.length + 1,
        itemBuilder: (context, indice) {
          // El primer elemento es el chip "Todas".
          if (indice == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Center(
                child: _ChipTodas(
                  activa: seleccionadas.isEmpty,
                  total: totalNotas,
                  onTap: onLimpiar,
                ),
              ),
            );
          }

          final etiqueta = etiquetas[indice - 1];
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Center(
              child: TagChip(
                etiqueta: etiqueta,
                seleccionada: seleccionadas.contains(etiqueta.id),
                cantidad: cantidadDe?.call(etiqueta.id),
                onTap: () => onAlternar(etiqueta.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChipTodas extends StatelessWidget {
  final bool activa;
  final int? total;
  final VoidCallback onTap;

  const _ChipTodas({
    required this.activa,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: activa ? AppColors.primary : AppColors.surfaceVariant,
      borderRadius: AppRadius.tag,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.tag,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            total == null ? 'Todas' : 'Todas $total',
            style: AppTextStyles.labelSm.copyWith(
              color: activa ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
