import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../routes/app_routes.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/tag_autocomplete_field.dart';
import '../widgets/tag_chip.dart';

/// RF3: editor para crear y editar una nota.
/// Trabaja sobre el borrador que guarda AppState.
class EditorNotaScreen extends StatefulWidget {
  const EditorNotaScreen({super.key});

  @override
  State<EditorNotaScreen> createState() => _EditorNotaScreenState();
}

class _EditorNotaScreenState extends State<EditorNotaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titulo;
  late final TextEditingController _descripcion;

  @override
  void initState() {
    super.initState();
    final borrador = AppStateScope.leer(context).borrador;
    _titulo = TextEditingController(text: borrador?.titulo ?? '');
    _descripcion = TextEditingController(text: borrador?.descripcion ?? '');
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  /// Guardar: valida el título, vuelve a la pantalla anterior y guarda.
  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final estado = AppStateScope.leer(context);
    final mensajes = ScaffoldMessenger.of(context);
    final esNueva = estado.borrador?.notaId == null;

    AppRoutes.volver(context);
    estado.guardarBorrador();
    mensajes.showSnackBar(
      SnackBar(content: Text(esNueva ? 'Nota creada' : 'Nota guardada')),
    );
  }

  /// Cancelar o botón atrás: si hay cambios sin guardar, pide confirmación.
  Future<void> _salir() async {
    final estado = AppStateScope.leer(context);
    final borrador = estado.borrador;

    if (borrador != null && borrador.hayCambios) {
      final descartar = await mostrarConfirmacion(
        context,
        titulo: 'Cambios sin guardar',
        mensaje: 'Si sales ahora perderás los cambios de esta nota.',
        textoConfirmar: 'Descartar',
        textoCancelar: 'Seguir editando',
        colorConfirmar: AppColors.warning,
      );
      if (!descartar || !mounted) return;
    }

    AppRoutes.volver(context);
    estado.descartarBorrador();
  }

  @override
  Widget build(BuildContext context) {
    final estado = AppStateScope.of(context);
    final borrador = estado.borrador;

    // No hay borrador (no debería ocurrir): se muestra una pantalla vacía.
    if (borrador == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    final asignadas = borrador.etiquetaIds
        .map(estado.etiquetaPorId)
        .whereType<Etiqueta>()
        .toList();

    return PopScope(
      // El botón atrás pasa por _salir(), que pregunta si hay cambios.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _salir();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Editor de nota')),
        // Todo el formulario hace scroll: no hay overflow con el teclado.
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: AppSpacing.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _campoTitulo(estado),
                const SizedBox(height: AppSpacing.xl),
                _seccionEtiquetas(estado, borrador, asignadas),
                const SizedBox(height: AppSpacing.xl),
                _campoDescripcion(estado),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _botones(),
      ),
    );
  }

  Widget _campoTitulo(AppState estado) {
    return TextFormField(
      controller: _titulo,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(labelText: 'Título *'),
      validator: (valor) => (valor == null || valor.trim().isEmpty)
          ? 'El título es obligatorio'
          : null,
      onChanged: estado.actualizarTituloBorrador,
    );
  }

  Widget _seccionEtiquetas(
    AppState estado,
    BorradorNota borrador,
    List<Etiqueta> asignadas,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Etiquetas', style: AppTextStyles.labelMd),
        const SizedBox(height: AppSpacing.sm),

        // Etiquetas ya asignadas, cada una con su botón para quitarla
        if (asignadas.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: 6,
            children: [
              for (final etiqueta in asignadas)
                TagChip(
                  etiqueta: etiqueta,
                  onDeleted: () =>
                      estado.quitarEtiquetaDelBorrador(etiqueta.id),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Campo con autocompletado
        TagAutocompleteField(
          buscarSugerencias: (texto) =>
              estado.sugerenciasEtiquetas(texto, borrador.etiquetaIds),
          existeEtiqueta: (nombre) =>
              estado.buscarEtiquetaPorNombre(nombre) != null,
          cantidadNotas: estado.cantidadNotasEtiqueta,
          onSeleccionar: (etiqueta) =>
              estado.asignarEtiquetaAlBorrador(etiqueta.id),
          onCrear: estado.crearYAsignarEtiquetaAlBorrador,
        ),
      ],
    );
  }

  Widget _campoDescripcion(AppState estado) {
    return TextFormField(
      controller: _descripcion,
      // Crece hasta 14 líneas; después tiene scroll interno.
      minLines: 8,
      maxLines: 14,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Descripción',
        alignLabelWithHint: true,
        hintText: 'Escribe aquí tu hallazgo o apunte...',
      ),
      onChanged: estado.actualizarDescripcionBorrador,
    );
  }

  Widget _botones() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _salir,
                child: const Text('Cancelar'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _guardar,
                icon: const Icon(Icons.check_rounded, size: 20),
                label: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
