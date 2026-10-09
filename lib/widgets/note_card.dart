import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../models/nota.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formato.dart';
import 'tag_wrap.dart';

/// Tarjeta de una nota. Se reutiliza en tres pantallas:
/// - Notas del proyecto: con [mostrarFecha] y [onDelete].
/// - Etiquetas: con [nombreProyecto].
/// - Buscar: con [nombreProyecto].
class NoteCard extends StatelessWidget {
  final Nota nota;
  final List<Etiqueta> etiquetas;
  final String? nombreProyecto; // si es null, no se muestra el proyecto
  final bool mostrarFecha;
  final VoidCallback onTap;
  final VoidCallback? onDelete; // si es null, no se muestra el menú

  const NoteCard({
    super.key,
    required this.nota,
    required this.etiquetas,
    this.nombreProyecto,
    this.mostrarFecha = false,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final resumen = extracto(nota.descripcion);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      nota.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMd,
                    ),
                  ),
                  _accion(),
                ],
              ),
              if (nombreProyecto != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _proyecto(),
              ],
              if (resumen.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  resumen,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMd,
                ),
              ],
              if (etiquetas.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                TagWrap(etiquetas: etiquetas),
              ],
              if (mostrarFecha) ...[
                const SizedBox(height: AppSpacing.md),
                _fecha(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Menú con Eliminar, o una flecha si la tarjeta no tiene menú.
  Widget _accion() {
    if (onDelete == null) {
      return const Padding(
        padding: EdgeInsets.only(left: AppSpacing.sm),
        child: Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
      );
    }
    return SizedBox(
      width: 32,
      height: 28,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        tooltip: 'Opciones de la nota',
        icon: const Icon(Icons.more_vert, color: AppColors.textTertiary),
        onSelected: (_) => onDelete!(),
        itemBuilder: (_) => [
          PopupMenuItem(
            value: 'eliminar',
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: AppColors.error,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'Eliminar',
                  style: AppTextStyles.labelMd.copyWith(color: AppColors.error),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _proyecto() {
    return Row(
      children: [
        const Icon(Icons.folder_outlined, size: 16, color: AppColors.secondary),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            nombreProyecto!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySm.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  Widget _fecha() {
    return Row(
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            'Modificado ${fechaRelativa(nota.fechaModificacion)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySm,
          ),
        ),
      ],
    );
  }
}
