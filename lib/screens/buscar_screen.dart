import 'package:flutter/material.dart';

import '../models/nota.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../widgets/campo_busqueda.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import '../widgets/tag_filter_bar.dart';

/// RF6: búsqueda global en las notas de todos los proyectos.
class BuscarScreen extends StatelessWidget {
  const BuscarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);
    final resultados = estado.resultadosBusqueda;

    return Scaffold(
      // El Scaffold de Inicio ya ajusta el espacio al teclado.
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Buscar')),
      // Todo hace scroll junto: el encabezado es el primer elemento y
      // los resultados van debajo, separados por un espacio.
      body: ListView.separated(
        padding: AppSpacing.screenPadding.copyWith(bottom: AppSpacing.lg),
        itemCount: resultados.length + 1,
        separatorBuilder: (context, indice) =>
            const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, indice) {
          if (indice == 0) return _encabezado(estado, resultados);

          final nota = resultados[indice - 1];
          return NoteCard(
            nota: nota,
            etiquetas: estado.etiquetasDeNota(nota),
            nombreProyecto: estado.proyectoPorId(nota.proyectoId)?.nombre,
            onTap: () => AppRoutes.abrirDetalleNota(context, nota.id),
          );
        },
      ),
    );
  }

  Widget _encabezado(AppState estado, List<Nota> resultados) {
    final filtros = estado.filtrosBusqueda;
    final etiquetas = estado.etiquetas;
    final cantidad = resultados.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CampoBusqueda(
          valorInicial: filtros.texto,
          hint: 'Buscar por título o contenido...',
          onChanged: estado.setTextoBusqueda,
        ),
        const SizedBox(height: AppSpacing.md),
        _filtroProyecto(estado),

        // Filtro opcional por etiquetas
        if (etiquetas.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          TagFilterBar(
            padding: EdgeInsets.zero,
            etiquetas: etiquetas,
            seleccionadas: filtros.etiquetaIds,
            onAlternar: estado.alternarEtiquetaBusqueda,
            onLimpiar: estado.limpiarEtiquetasBusqueda,
          ),
        ],
        const SizedBox(height: AppSpacing.lg),

        // Cantidad de resultados y botón para limpiar los filtros
        Row(
          children: [
            Expanded(
              child: Text(
                cantidad == 1
                    ? '1 nota encontrada'
                    : '$cantidad notas encontradas',
                style: AppTextStyles.titleMd,
              ),
            ),
            if (filtros.activo)
              TextButton(
                onPressed: estado.limpiarFiltrosBusqueda,
                child: const Text('Limpiar filtros'),
              ),
          ],
        ),

        // Mensaje cuando no hay resultados
        if (cantidad == 0)
          EmptyState(
            compacto: true,
            icono: Icons.search_off_rounded,
            titulo: filtros.activo ? 'Sin resultados' : 'Aún no hay notas',
            mensaje: filtros.activo
                ? 'Prueba con otras palabras o quita algunos filtros.'
                : 'Crea una nota desde un proyecto para poder buscarla aquí.',
          ),
      ],
    );
  }

  /// Menú para filtrar por un proyecto, o por todos.
  Widget _filtroProyecto(AppState estado) {
    return InputDecorator(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.folder_outlined),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: estado.filtrosBusqueda.proyectoId,
          isExpanded: true,
          borderRadius: AppRadius.input,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: AppTextStyles.bodyMd.copyWith(color: AppColors.textPrimary),
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Todos los proyectos'),
            ),
            for (final proyecto in estado.proyectos)
              DropdownMenuItem<String?>(
                value: proyecto.id,
                child: Text(
                  proyecto.nombre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: estado.setProyectoBusqueda,
        ),
      ),
    );
  }
}
