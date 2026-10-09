import 'package:flutter/material.dart';

import '../models/proyecto.dart';
import '../state/app_state.dart';
import '../theme/app_dimensions.dart';

/// Abre el formulario de proyecto.
/// - Sin [proyecto]: crea uno nuevo.
/// - Con [proyecto]: edita su nombre y descripción.
Future<void> mostrarFormularioProyecto(
  BuildContext context, {
  Proyecto? proyecto,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _FormularioProyecto(proyecto: proyecto),
  );
}

class _FormularioProyecto extends StatefulWidget {
  final Proyecto? proyecto;

  const _FormularioProyecto({this.proyecto});

  @override
  State<_FormularioProyecto> createState() => _FormularioProyectoState();
}

class _FormularioProyectoState extends State<_FormularioProyecto> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombre =
      TextEditingController(text: widget.proyecto?.nombre ?? '');
  late final TextEditingController _descripcion =
      TextEditingController(text: widget.proyecto?.descripcion ?? '');

  bool get _editando => widget.proyecto != null;

  @override
  void dispose() {
    _nombre.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final estado = AppStateScope.leer(context);
    final error = _editando
        ? estado.editarProyecto(
            widget.proyecto!.id,
            _nombre.text,
            _descripcion.text,
          )
        : estado.crearProyecto(_nombre.text, _descripcion.text);

    if (error == null) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_editando ? 'Editar proyecto' : 'Nuevo proyecto'),
      // El scroll evita overflow con el teclado abierto.
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombre,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (valor) => (valor == null || valor.trim().isEmpty)
                    ? 'El nombre del proyecto es obligatorio'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descripcion,
                minLines: 2,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
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
