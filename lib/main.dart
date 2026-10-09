import 'package:flutter/material.dart';

import 'routes/app_routes.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ReNotesApp());

class ReNotesApp extends StatefulWidget {
  const ReNotesApp({super.key});

  @override
  State<ReNotesApp> createState() => _ReNotesAppState();
}

class _ReNotesAppState extends State<ReNotesApp> {
  final AppState _estado = AppState();

  @override
  void dispose() {
    _estado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _estado,
      child: MaterialApp(
        title: 'ReNotes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.inicio,
        routes: AppRoutes.rutas,
      ),
    );
  }
}