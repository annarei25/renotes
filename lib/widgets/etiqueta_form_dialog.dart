import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../state/app_state.dart';
import '../theme/app_dimensions.dart';

/// Abre el formulario de etiqueta.
/// - Sin [etiqueta]: crea una etiqueta nueva, independiente de cualquier nota.
/// - Con [etiqueta]: la renombra (el cambio se ve en todas las notas).
Future<void> mostrarFormularioEtiqueta(
  BuildContext context, {
  Etiqueta? etiqueta,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _FormularioEtiqueta(etiqueta: etiqueta),
  );
}

class _FormularioEtiqueta extends StatefulWidget {
  final Etiqueta? etiqueta;

  const _FormularioEtiqueta({this.etiqueta});

  @override
  State<_FormularioEtiqueta> createState() => _FormularioEtiquetaState();
}

class _FormularioEtiquetaState extends State<_FormularioEtiqueta> {
  late final TextEditingController _nombre =
      TextEditingController(text: widget.etiqueta?.nombre ?? '');
  String? _error;

  bool get _editando => widget.etiqueta != null;

  @override
  void dispose() {
    _nombre.dispose();
    super.dispose();
  }

  void _guardar() {
    final estado = AppStateScope.leer(context);
    final error = _editando
        ? estado.renombrarEtiqueta(widget.etiqueta!.id, _nombre.text)
        : estado.crearEtiqueta(_nombre.text);

    if (error == null) {
      Navigator.pop(context);
    } else {
      // Por ejemplo: "Ya existe una etiqueta con ese nombre".
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editando ? 'Renombrar etiqueta' : 'Nueva etiqueta'),
      // El scroll evita overflow con el teclado abierto.
      content: SingleChildScrollView(
        child: TextField(
          controller: _nombre,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _guardar(),
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          decoration: InputDecoration(
            labelText: 'Nombre de la etiqueta',
            prefixText: '#',
            errorText: _error,
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardar,
          child: Text(_editando ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}
