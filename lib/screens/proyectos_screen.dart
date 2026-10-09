import 'package:flutter/material.dart';

import '../models/proyecto.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';
import '../theme/app_dimensions.dart';
import '../utils/formato.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state.dart';
import '../widgets/project_card.dart';
import '../widgets/proyecto_form_dialog.dart';

/// RF1: lista de proyectos de investigación.
class ProyectosScreen extends StatelessWidget {
  const ProyectosScreen({super.key});

  Future<void> _eliminar(BuildContext context, Proyecto proyecto) async {
    final estado = AppStateScope.leer(context);
    final cantidad = estado.cantidadNotasProyecto(proyecto.id);
    final detalleNotas = cantidad == 0
        ? ''
        : ' junto con ${textoNotas(cantidad)}';

    final confirmado = await mostrarConfirmacion(
      context,
      titulo: 'Eliminar proyecto',
      mensaje: 'Se eliminará "${proyecto.nombre}"$detalleNotas. '
          'Las etiquetas no se eliminan.',
    );
    if (confirmado) estado.eliminarProyecto(proyecto.id);
  }

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);
    final proyectos = estado.proyectos;

    return Scaffold(
      appBar: AppBar(title: const Text('Proyectos')),
      body: proyectos.isEmpty
          ? const EmptyState(
              icono: Icons.folder_open_rounded,
              titulo: 'Aún no hay proyectos',
              mensaje: 'Crea tu primer proyecto de investigación con el '
                  'botón "Nuevo proyecto".',
            )
          : ListView.builder(
              // El espacio inferior evita que el botón tape la última tarjeta.
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                88,
              ),
              itemCount: proyectos.length,
              itemBuilder: (context, indice) {
                final proyecto = proyectos[indice];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: ProjectCard(
                    proyecto: proyecto,
                    cantidadNotas: estado.cantidadNotasProyecto(proyecto.id),
                    onTap: () =>
                        AppRoutes.abrirNotasProyecto(context, proyecto.id),
                    onEdit: () =>
                        mostrarFormularioProyecto(context, proyecto: proyecto),
                    onDelete: () => _eliminar(context, proyecto),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => mostrarFormularioProyecto(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo proyecto'),
      ),
    );
  }
}
