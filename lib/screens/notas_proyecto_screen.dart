import 'package:flutter/material.dart';

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
import '../widgets/note_card.dart';
import '../widgets/tag_filter_bar.dart';

/// RF2: notas del proyecto abierto, con búsqueda y filtro por etiquetas.
class NotasProyectoScreen extends StatelessWidget {
  const NotasProyectoScreen({super.key});

  Future<void> _eliminar(BuildContext context, Nota nota) async {
    final estado = AppStateScope.leer(context);
    final confirmado = await mostrarConfirmacion(
      context,
      titulo: 'Eliminar nota',
      mensaje: '¿Eliminar "${nota.titulo}"? Esta acción no se puede deshacer.',
    );
    if (confirmado) estado.eliminarNota(nota.id);
  }

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);
    final proyecto = estado.proyectoAbierto;

    // El proyecto ya no existe (por ejemplo, fue eliminado).
    if (proyecto == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    final totalNotas = estado.cantidadNotasProyecto(proyecto.id);
    final notas = estado.notasFiltradasProyecto;
    final etiquetasDelProyecto = estado.etiquetasDelProyecto(proyecto.id);
    final filtros = estado.filtrosProyecto;

    return Scaffold(
      // El teclado se dibuja encima: la lista no se aprieta ni hay overflow.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Notas del proyecto')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del proyecto y cantidad de notas
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proyecto.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMd,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(
                      Icons.article_outlined,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      textoNotas(totalNotas),
                      style: AppTextStyles.labelSm
                          .copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Búsqueda por título o contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: CampoBusqueda(
              valorInicial: filtros.texto,
              hint: 'Buscar por título o contenido...',
              onChanged: estado.setTextoProyecto,
            ),
          ),

          // Filtro por etiquetas (solo las que están en notas del proyecto)
          if (etiquetasDelProyecto.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            TagFilterBar(
              etiquetas: etiquetasDelProyecto,
              seleccionadas: filtros.etiquetaIds,
              totalNotas: totalNotas,
              cantidadDe: (id) =>
                  estado.cantidadNotasEtiquetaEnProyecto(proyecto.id, id),
              onAlternar: estado.alternarEtiquetaProyecto,
              onLimpiar: estado.limpiarEtiquetasProyecto,
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          // Lista de notas o mensaje de lista vacía
          Expanded(child: _contenido(context, estado, totalNotas, notas)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => AppRoutes.abrirEditorNuevaNota(context, proyecto.id),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva nota'),
      ),
    );
  }

  Widget _contenido(
    BuildContext context,
    AppState estado,
    int totalNotas,
    List<Nota> notas,
  ) {
    if (totalNotas == 0) {
      return const EmptyState(
        icono: Icons.note_alt_outlined,
        titulo: 'Este proyecto no tiene notas',
        mensaje: 'Crea la primera con el botón "Nueva nota".',
      );
    }
    if (notas.isEmpty) {
      return const EmptyState(
        icono: Icons.search_off_rounded,
        titulo: 'Sin resultados',
        mensaje: 'Ninguna nota coincide con la búsqueda o los filtros.',
      );
    }

    return ListView.builder(
      // El espacio inferior evita que el botón tape la última nota.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        88,
      ),
      itemCount: notas.length,
      itemBuilder: (context, indice) {
        final nota = notas[indice];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: NoteCard(
            nota: nota,
            etiquetas: estado.etiquetasDeNota(nota),
            mostrarFecha: true,
            onTap: () => AppRoutes.abrirDetalleNota(context, nota.id),
            onDelete: () => _eliminar(context, nota),
          ),
        );
      },
    );
  }
}
