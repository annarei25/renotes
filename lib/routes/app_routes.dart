import 'package:flutter/material.dart';

import '../screens/detalle_nota_screen.dart';
import '../screens/editor_nota_screen.dart';
import '../screens/inicio_screen.dart';
import '../screens/notas_proyecto_screen.dart';
import '../state/app_state.dart';

/// Rutas de la app. Todo el proyecto navega solo con Navigator.pushNamed.
///
/// Las pantallas no reciben argumentos: el proyecto abierto, la nota abierta
/// y el borrador viven en AppState, que se prepara antes de navegar.
class AppRoutes {
  AppRoutes._();

  // Nombres de ruta
  static const String inicio = '/'; // contiene las 3 pestañas
  static const String notasProyecto = '/notas-proyecto';
  static const String detalleNota = '/detalle-nota';
  static const String editorNota = '/editor-nota';

  static Map<String, WidgetBuilder> get rutas => {
        inicio: (_) => const InicioScreen(),
        notasProyecto: (_) => const NotasProyectoScreen(),
        detalleNota: (_) => const DetalleNotaScreen(),
        editorNota: (_) => const EditorNotaScreen(),
      };

  // ---------------------------------------------------------------------------
  // Funciones de navegación (RF7). Las pantallas llaman a estas funciones.
  // ---------------------------------------------------------------------------

  /// Proyectos -> Notas del proyecto
  static void abrirNotasProyecto(BuildContext context, String proyectoId) {
    AppStateScope.leer(context).abrirProyecto(proyectoId);
    Navigator.pushNamed(context, notasProyecto);
  }

  /// Notas del proyecto / Etiquetas / Buscar -> Detalle de nota
  static void abrirDetalleNota(BuildContext context, String notaId) {
    AppStateScope.leer(context).abrirNota(notaId);
    Navigator.pushNamed(context, detalleNota);
  }

  /// Notas del proyecto -> Editor de nota (crear)
  static void abrirEditorNuevaNota(BuildContext context, String proyectoId) {
    AppStateScope.leer(context).iniciarBorrador(proyectoId: proyectoId);
    Navigator.pushNamed(context, editorNota);
  }

  /// Detalle de nota -> Editor de nota (editar)
  static void abrirEditorEditarNota(BuildContext context, String notaId) {
    AppStateScope.leer(context).iniciarBorrador(notaId: notaId);
    Navigator.pushNamed(context, editorNota);
  }

  /// Detalle de nota -> Etiquetas filtrada por una etiqueta.
  /// Vuelve a la pantalla principal y deja seleccionada la pestaña Etiquetas.
  static void abrirEtiquetasFiltradas(BuildContext context, String etiquetaId) {
    AppStateScope.leer(context).filtrarEtiquetasPor(etiquetaId);
    Navigator.popUntil(context, ModalRoute.withName(inicio));
  }

  /// Detalle de nota o Editor -> pantalla anterior
  static void volver(BuildContext context) => Navigator.pop(context);
}
