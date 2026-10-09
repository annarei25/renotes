import 'package:flutter/material.dart';

import '../models/proyecto.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formato.dart';

enum _AccionProyecto { editar, eliminar }

/// Tarjeta de un proyecto: nombre, descripción corta, cantidad de notas,
/// fecha de última modificación y menú con Editar y Eliminar.
class ProjectCard extends StatelessWidget {
  final Proyecto proyecto;
  final int cantidadNotas;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.proyecto,
    required this.cantidadNotas,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                children: [
                  Expanded(
                    child: Text(
                      proyecto.nombre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleLg,
                    ),
                  ),
                  _menu(),
                ],
              ),
              if (proyecto.descripcion.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  proyecto.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMd,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _contadorNotas(),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(child: _fecha()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menu() {
    return PopupMenuButton<_AccionProyecto>(
      padding: EdgeInsets.zero,
      tooltip: 'Opciones del proyecto',
      icon: const Icon(Icons.more_vert, color: AppColors.textTertiary),
      onSelected: (accion) {
        if (accion == _AccionProyecto.editar) onEdit();
        if (accion == _AccionProyecto.eliminar) onDelete();
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: _AccionProyecto.editar,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: AppSpacing.md),
              Text('Editar'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _AccionProyecto.eliminar,
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
    );
  }

  Widget _contadorNotas() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.tagPalette[1].bg, // azul claro
        borderRadius: AppRadius.tag,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.article_outlined, size: 16, color: AppColors.secondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            textoNotas(cantidadNotas),
            style: AppTextStyles.labelSm.copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _fecha() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.access_time_rounded,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            'Modificado ${fechaRelativa(proyecto.fechaModificacion)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodySm,
          ),
        ),
      ],
    );
  }
}
