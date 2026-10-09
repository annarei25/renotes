import 'package:flutter/material.dart';

/// BottomNavigationBar con los tres destinos principales (RF7).
/// Los colores y estilos vienen de AppTheme.
class AppTabBar extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int> onCambio;

  const AppTabBar({
    super.key,
    required this.indiceActual,
    required this.onCambio,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,
      onTap: onCambio,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.folder_outlined),
          activeIcon: Icon(Icons.folder),
          label: 'Proyectos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.label_outlined),
          activeIcon: Icon(Icons.label),
          label: 'Etiquetas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_rounded),
          activeIcon: Icon(Icons.search_rounded),
          label: 'Buscar',
        ),
      ],
    );
  }
}
