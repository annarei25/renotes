import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/app_tab_bar.dart';
import 'buscar_screen.dart';
import 'etiquetas_screen.dart';
import 'proyectos_screen.dart';

/// Pantalla principal: contiene el BottomNavigationBar y las tres pestañas.
///
/// IndexedStack mantiene las tres pestañas creadas al mismo tiempo, así cada
/// una conserva su texto de búsqueda, filtros y posición de scroll (RF7).
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);

    return Scaffold(
      body: IndexedStack(
        index: estado.pestanaActual,
        children: const [
          ProyectosScreen(),
          EtiquetasScreen(),
          BuscarScreen(),
        ],
      ),
      bottomNavigationBar: AppTabBar(
        indiceActual: estado.pestanaActual,
        onCambio: estado.cambiarPestana,
      ),
    );
  }
}
