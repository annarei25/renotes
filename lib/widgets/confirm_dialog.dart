import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

/// Muestra un diálogo de confirmación. Devuelve true si el usuario confirma
/// y false si cancela o cierra el diálogo.
///
/// Eliminar:
/// ```dart
/// final ok = await mostrarConfirmacion(
///   context,
///   titulo: 'Eliminar proyecto',
///   mensaje: 'Se eliminarán también sus notas.',
/// );
/// ```
///
/// Descartar cambios (color de aviso):
/// ```dart
/// final salir = await mostrarConfirmacion(
///   context,
///   titulo: 'Cambios sin guardar',
///   mensaje: '¿Quieres salir sin guardar?',
///   textoConfirmar: 'Descartar',
///   textoCancelar: 'Seguir editando',
///   colorConfirmar: AppColors.warning,
/// );
/// ```
Future<bool> mostrarConfirmacion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  String textoConfirmar = 'Eliminar',
  String textoCancelar = 'Cancelar',
  Color colorConfirmar = AppColors.error,
}) async {
  final resultado = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(textoCancelar),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: colorConfirmar),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(textoConfirmar),
        ),
      ],
    ),
  );
  return resultado ?? false;
}
