import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../models/nota.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formato.dart';
import '../widgets/campo_busqueda.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/etiqueta_form_dialog.dart';
import '../widgets/note_card.dart';
import '../widgets/tag_chip.dart';

enum _AccionEtiqueta { renombrar, eliminar }

/// RF5: gestión de etiquetas y agrupación de notas de todos los proyectos.
class EtiquetasScreen extends StatelessWidget {
  const EtiquetasScreen({super.key});

  Future<void> _eliminar(BuildContext context, Etiqueta etiqueta) async {
    final estado = AppStateScope.leer(context);
    final cantidad = estado.cantidadNotasEtiqueta(etiqueta.id);
    final detalle = cantidad == 0
        ? 'No está asignada a ninguna nota.'
        : 'Se quitará de ${textoNotas(cantidad)}. Las notas no se eliminan.';

    final confirmado = await mostrarConfirmacion(
      context,
      titulo: 'Eliminar etiqueta',
      mensaje: '¿Eliminar la etiqueta "#${etiqueta.nombre}"? $detalle',
    );
    if (confirmado) estado.eliminarEtiqueta(etiqueta.id);
  }

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);
    final hayEtiquetas = estado.etiquetas.isNotEmpty;
    final notas = estado.notasPorEtiquetasSeleccionadas;

    return Scaffold(
      // El Scaffold de Inicio ya ajusta el espacio al teclado.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Etiquetas')),
      body: !hayEtiquetas
          ? const EmptyState(
              icono: Icons.label_outlined,
              titulo: 'Aún no hay etiquetas',
              mensaje: 'Crea una con el botón "Nueva etiqueta" o desde el '
                  'editor de una nota.',
            )
          : ListView.builder(
              // Todo hace scroll junto: el encabezado es el primer elemento.
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                88,
              ),
              itemCount: notas.length + 1,
              itemBuilder: (context, indice) {
                if (indice == 0) return _encabezado(context, estado, notas);

                final nota = notas[indice - 1];
                return Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  child: NoteCard(
                    nota: nota,
                    etiquetas: estado.etiquetasDeNota(nota),
                    nombreProyecto: estado.proyectoPorId(nota.proyectoId)?.nombre,
                    onTap: () => AppRoutes.abrirDetalleNota(context, nota.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => mostrarFormularioEtiqueta(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva etiqueta'),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Encabezado: búsqueda, modo, etiquetas y resumen de resultados
  // ---------------------------------------------------------------------------

  Widget _encabezado(BuildContext context, AppState estado, List<Nota> notas) {
    final visibles = estado.etiquetasVisibles;
    final seleccionadas = estado.etiquetasSeleccionadas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CampoBusqueda(
          valorInicial: estado.textoBusquedaEtiquetas,
          hint: 'Buscar etiqueta por nombre...',
          onChanged: estado.setTextoBusquedaEtiquetas,
        ),
        const SizedBox(height: AppSpacing.lg),
        _selectorModo(estado),
        const SizedBox(height: AppSpacing.lg),

        // Lista de etiquetas
        Row(
          children: [
            const Icon(
              Icons.local_offer_outlined,
              size: 16,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text('Todas las etiquetas', style: AppTextStyles.labelMd),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (visibles.isEmpty)
          const Text(
            'Ninguna etiqueta coincide con la búsqueda.',
            style: AppTextStyles.bodyMd,
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final etiqueta in visibles)
                TagChip(
                  etiqueta: etiqueta,
                  cantidad: estado.cantidadNotasEtiqueta(etiqueta.id),
                  seleccionada: seleccionadas.contains(etiqueta.id),
                  onTap: () => estado.alternarEtiquetaSeleccionada(etiqueta.id),
                  trailing: _menu(context, etiqueta),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),

        _resumen(estado, notas),
      ],
    );
  }

  /// Elige si ver las notas con todas las etiquetas o con al menos una.
  Widget _selectorModo(AppState estado) {
    final todas = estado.modoEtiquetas == ModoFiltro.todas;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ModoFiltro>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: ModoFiltro.todas, label: Text('Todas')),
              ButtonSegment(
                value: ModoFiltro.alMenosUna,
                label: Text('Al menos una'),
              ),
            ],
            selected: {estado.modoEtiquetas},
            onSelectionChanged: (seleccion) =>
                estado.setModoEtiquetas(seleccion.first),
            style: SegmentedButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              foregroundColor: AppColors.textSecondary,
              selectedBackgroundColor: AppColors.primary,
              selectedForegroundColor: Colors.white,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          todas
              ? 'Muestra las notas que tienen todas las etiquetas elegidas.'
              : 'Muestra las notas que tienen al menos una de las etiquetas '
                  'elegidas.',
          style: AppTextStyles.bodySm,
        ),
      ],
    );
  }

  /// Menú de cada etiqueta: renombrar y eliminar.
  Widget _menu(BuildContext context, Etiqueta etiqueta) {
    return PopupMenuButton<_AccionEtiqueta>(
      padding: EdgeInsets.zero,
      tooltip: 'Opciones de la etiqueta',
      onSelected: (accion) {
        if (accion == _AccionEtiqueta.renombrar) {
          mostrarFormularioEtiqueta(context, etiqueta: etiqueta);
        } else {
          _eliminar(context, etiqueta);
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: _AccionEtiqueta.renombrar,
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: AppSpacing.md),
              Text('Renombrar'),
            ],
          ),
        ),
        PopupMenuItem(
          value: _AccionEtiqueta.eliminar,
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
      // Con "child" el botón mide solo lo que mide el icono.
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.xs),
        child: Icon(Icons.more_vert, size: 16, color: AppColors.textSecondary),
      ),
    );
  }

  /// Texto sobre los resultados: indicaciones, conteo o mensaje sin resultados.
  Widget _resumen(AppState estado, List<Nota> notas) {
    final seleccionadas = estado.etiquetasSeleccionadas;

    if (seleccionadas.isEmpty) {
      return Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.card,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.touch_app_outlined,
              size: 20,
              color: AppColors.textTertiary,
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Text(
                'Toca una o varias etiquetas para ver sus notas.',
                style: AppTextStyles.bodyMd,
              ),
            ),
          ],
        ),
      );
    }

    final proyectos = notas.map((n) => n.proyectoId).toSet().length;
    final textoProyectos = proyectos == 1 ? '1 proyecto' : '$proyectos proyectos';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Notas que coinciden', style: AppTextStyles.titleMd),
            ),
            TextButton(
              onPressed: estado.limpiarSeleccionEtiquetas,
              child: const Text('Limpiar selección'),
            ),
          ],
        ),
        if (notas.isEmpty)
          Text(
            estado.modoEtiquetas == ModoFiltro.todas
                ? 'Ninguna nota tiene todas las etiquetas seleccionadas.'
                : 'Ninguna nota tiene alguna de las etiquetas seleccionadas.',
            style: AppTextStyles.bodyMd,
          )
        else
          Text(
            '${textoNotas(notas.length)} en $textoProyectos',
            style: AppTextStyles.bodyMd,
          ),
      ],
    );
  }
}
