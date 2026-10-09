import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';

/// Chip de una etiqueta. Se usa de cuatro formas:
/// - Solo lectura: `TagChip(etiqueta: e)`
/// - Tocable: con [onTap]
/// - Con botón de quitar (Editor): con [onDeleted]
/// - Filtro: con [seleccionada] y, si se quiere, [cantidad]
/// - Con acciones: [trailing] agrega un widget al final (menú ⋮)
class TagChip extends StatelessWidget {
  final Etiqueta etiqueta;
  final int? cantidad;
  final bool seleccionada;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final Widget? trailing; // widget extra al final (ej: menú de opciones)

  const TagChip({
    super.key,
    required this.etiqueta,
    this.cantidad,
    this.seleccionada = false,
    this.onTap,
    this.onDeleted,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colores = AppColors.tagColors(etiqueta.colorIndex);
    final borde = seleccionada
        ? colores.text
        : colores.text.withValues(alpha: 0.2);

    return Material(
      color: colores.bg,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.tag,
        side: BorderSide(color: borde),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.tag,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: onDeleted != null ? 3 : AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (seleccionada) ...[
                Icon(Icons.check_rounded, size: 14, color: colores.text),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  '#${etiqueta.nombre}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSm.copyWith(color: colores.text),
                ),
              ),
              if (cantidad != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '$cantidad',
                  style: AppTextStyles.labelSm.copyWith(
                    color: colores.text.withValues(alpha: 0.7),
                  ),
                ),
              ],
              if (onDeleted != null) ...[
                const SizedBox(width: AppSpacing.xs),
                GestureDetector(
                  onTap: onDeleted,
                  behavior: HitTestBehavior.opaque,
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.xs),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.xs),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
