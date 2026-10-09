import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../models/nota.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formato.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/tag_wrap.dart';

/// RF4: detalle de la nota abierta.
class DetalleNotaScreen extends StatelessWidget {
  const DetalleNotaScreen({super.key});

  Future<void> _eliminar(BuildContext context, Nota nota) async {
    final estado = AppStateScope.leer(context);
    final confirmado = await mostrarConfirmacion(
      context,
      titulo: 'Eliminar nota',
      mensaje: '¿Eliminar "${nota.titulo}"? Esta acción no se puede deshacer.',
    );
    if (!confirmado || !context.mounted) return;

    // Primero se vuelve al listado y luego se elimina, para que esta
    // pantalla no se reconstruya sin nota.
    AppRoutes.volver(context);
    estado.eliminarNota(nota.id);
  }

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);
    final nota = estado.notaAbierta;

    // La nota ya no existe (por ejemplo, fue eliminada).
    if (nota == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    final proyecto = estado.proyectoPorId(nota.proyectoId);
    final etiquetas = estado.etiquetasDeNota(nota);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de nota')),
      // Todo el contenido está en un área con scroll: no hay overflow.
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(nota.titulo, style: AppTextStyles.headlineLg),
            const SizedBox(height: AppSpacing.sm),
            _proyecto(proyecto?.nombre ?? 'Proyecto eliminado'),
            const SizedBox(height: AppSpacing.lg),
            _fechas(nota),
            const SizedBox(height: AppSpacing.lg),
            _etiquetas(context, etiquetas),
            const SizedBox(height: AppSpacing.lg),
            _descripcion(nota),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      bottomNavigationBar: _botones(context, nota),
    );
  }

  Widget _proyecto(String nombre) {
    return Row(
      children: [
        const Icon(Icons.folder_outlined, size: 18, color: AppColors.secondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            nombre,
            style: AppTextStyles.labelMd.copyWith(color: AppColors.secondary),
          ),
        ),
      ],
    );
  }

  Widget _fechas(Nota nota) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _filaFecha(
              Icons.calendar_today_outlined,
              'Creada: ${fechaCompleta(nota.fechaCreacion)}',
            ),
            const SizedBox(height: AppSpacing.sm),
            _filaFecha(
              Icons.access_time_rounded,
              'Última modificación: ${fechaCompleta(nota.fechaModificacion)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _filaFecha(IconData icono, String texto) {
    return Row(
      children: [
        Icon(icono, size: 16, color: AppColors.textTertiary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(texto, style: AppTextStyles.bodyMd)),
      ],
    );
  }

  Widget _etiquetas(BuildContext context, List<Etiqueta> etiquetas) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.local_offer_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Etiquetas', style: AppTextStyles.labelMd),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (etiquetas.isEmpty)
              const Text('Esta nota no tiene etiquetas.',
                  style: AppTextStyles.bodyMd)
            else ...[
              Text(
                'Toca una etiqueta para ver las notas que la comparten.',
                style: AppTextStyles.bodySm,
              ),
              const SizedBox(height: AppSpacing.md),
              TagWrap(
                etiquetas: etiquetas,
                onTap: (etiqueta) =>
                    AppRoutes.abrirEtiquetasFiltradas(context, etiqueta.id),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _descripcion(Nota nota) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: nota.descripcion.trim().isEmpty
            ? Text(
                'Esta nota no tiene descripción.',
                style: AppTextStyles.bodyMd.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textTertiary,
                ),
              )
            : SelectableText(nota.descripcion, style: AppTextStyles.bodyLg),
      ),
    );
  }

  Widget _botones(BuildContext context, Nota nota) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorBg,
                  foregroundColor: AppColors.error,
                ),
                onPressed: () => _eliminar(context, nota),
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                label: const Text('Eliminar'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    AppRoutes.abrirEditorEditarNota(context, nota.id),
                icon: const Icon(Icons.edit_outlined, size: 20),
                label: const Text('Editar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
