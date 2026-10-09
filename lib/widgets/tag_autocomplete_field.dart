import 'package:flutter/material.dart';

import '../models/etiqueta.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/formato.dart';

/// Una opción de la lista de sugerencias: una etiqueta existente
/// o la opción "Crear etiqueta".
class OpcionEtiqueta {
  final Etiqueta? etiqueta; // null si es una etiqueta nueva
  final String nombre;

  OpcionEtiqueta.existente(Etiqueta etiqueta)
      : etiqueta = etiqueta,
        nombre = etiqueta.nombre;

  OpcionEtiqueta.nueva(this.nombre) : etiqueta = null;

  bool get esNueva => etiqueta == null;
}

/// Campo de etiquetas con autocompletado (RF3).
///
/// - Mientras se escribe, sugiere etiquetas existentes de cualquier proyecto.
/// - Si el texto no coincide con ninguna etiqueta, ofrece crearla.
/// - También confirma con la tecla de acción (Enter) o al escribir una coma.
///
/// El widget no conoce AppState: recibe funciones, así se puede reutilizar.
class TagAutocompleteField extends StatefulWidget {
  /// Etiquetas que coinciden con el texto (sin las ya asignadas a la nota).
  final List<Etiqueta> Function(String texto) buscarSugerencias;

  /// True si ya existe una etiqueta con ese nombre (en cualquier lugar).
  final bool Function(String nombre) existeEtiqueta;

  /// Cantidad de notas que usan una etiqueta (para el texto de la sugerencia).
  final int Function(String etiquetaId)? cantidadNotas;

  /// Se llama al tocar una sugerencia existente.
  final ValueChanged<Etiqueta> onSeleccionar;

  /// Se llama al crear una etiqueta nueva o al confirmar un texto.
  /// Si el nombre ya existe, quien la reciba debe reutilizar la existente.
  final ValueChanged<String> onCrear;

  const TagAutocompleteField({
    super.key,
    required this.buscarSugerencias,
    required this.existeEtiqueta,
    this.cantidadNotas,
    required this.onSeleccionar,
    required this.onCrear,
  });

  @override
  State<TagAutocompleteField> createState() => _TagAutocompleteFieldState();
}

class _TagAutocompleteFieldState extends State<TagAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _campoKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Quita espacios y los # del inicio.
  String _limpiar(String texto) {
    var limpio = texto.trim();
    while (limpio.startsWith('#')) {
      limpio = limpio.substring(1).trim();
    }
    return limpio;
  }

  /// Opciones que se muestran según el texto escrito.
  List<OpcionEtiqueta> _opciones(TextEditingValue valor) {
    final texto = _limpiar(valor.text);
    if (texto.isEmpty || texto.contains(',')) return [];

    final opciones = widget
        .buscarSugerencias(texto)
        .map(OpcionEtiqueta.existente)
        .toList();

    // Si no hay una etiqueta con ese nombre exacto, se ofrece crearla.
    if (!widget.existeEtiqueta(texto)) {
      opciones.add(OpcionEtiqueta.nueva(texto));
    }
    return opciones;
  }

  /// Se tocó una opción de la lista. El campo se limpia solo, porque
  /// displayStringForOption devuelve un texto vacío.
  void _alSeleccionar(OpcionEtiqueta opcion) {
    if (opcion.esNueva) {
      widget.onCrear(opcion.nombre);
    } else {
      widget.onSeleccionar(opcion.etiqueta!);
    }
    _focusNode.requestFocus();
  }

  /// Enter o botón "+": confirma lo que está escrito.
  void _confirmarTexto() {
    final texto = _limpiar(_controller.text);
    if (texto.isNotEmpty) widget.onCrear(texto);
    _controller.clear();
    _focusNode.requestFocus();
  }

  /// Al escribir una coma, se confirma el texto anterior a la coma.
  void _alCambiar(String texto) {
    if (!texto.contains(',')) return;

    final partes = texto.split(',');
    final resto = partes.removeLast();
    for (final parte in partes) {
      final nombre = _limpiar(parte);
      if (nombre.isNotEmpty) widget.onCrear(nombre);
    }
    _controller.value = TextEditingValue(
      text: resto,
      selection: TextSelection.collapsed(offset: resto.length),
    );
  }

  /// Altura disponible para la lista: entre el campo y el teclado.
  double _alturaMaxima(BuildContext overlayContext) {
    final caja = _campoKey.currentContext?.findRenderObject() as RenderBox?;
    if (caja == null || !caja.attached) return 200;

    final bordeInferior = caja.localToGlobal(Offset(0, caja.size.height)).dy;
    final pantalla = MediaQuery.of(overlayContext);
    final disponible =
        pantalla.size.height - pantalla.viewInsets.bottom - bordeInferior - 8;
    return disponible.clamp(96.0, 240.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        return RawAutocomplete<OpcionEtiqueta>(
          textEditingController: _controller,
          focusNode: _focusNode,
          displayStringForOption: (_) => '',
          optionsBuilder: _opciones,
          onSelected: _alSeleccionar,
          fieldViewBuilder: (context, controller, focusNode, alEnviar) {
            return TextField(
              key: _campoKey,
              controller: controller,
              focusNode: focusNode,
              onChanged: _alCambiar,
              onEditingComplete: _confirmarTexto,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'Escribe una etiqueta...',
                prefixIcon: const Icon(Icons.local_offer_outlined, size: 20),
                suffixIcon: IconButton(
                  tooltip: 'Agregar etiqueta',
                  icon: const Icon(Icons.add_rounded),
                  onPressed: _confirmarTexto,
                ),
              ),
            );
          },
          optionsViewBuilder: (context, alElegir, opciones) {
            return Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Material(
                  elevation: 8,
                  color: AppColors.surface,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.input,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: restricciones.maxWidth,
                      maxHeight: _alturaMaxima(context),
                    ),
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      shrinkWrap: true,
                      itemCount: opciones.length,
                      itemBuilder: (context, indice) {
                        final opcion = opciones.elementAt(indice);
                        return _FilaOpcion(
                          opcion: opcion,
                          cantidadNotas: opcion.esNueva
                              ? null
                              : widget.cantidadNotas?.call(opcion.etiqueta!.id),
                          onTap: () => alElegir(opcion),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Una fila de la lista de sugerencias.
class _FilaOpcion extends StatelessWidget {
  final OpcionEtiqueta opcion;
  final int? cantidadNotas;
  final VoidCallback onTap;

  const _FilaOpcion({
    required this.opcion,
    required this.cantidadNotas,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String titulo;
    final String? detalle;
    final Color fondoIcono;
    final Color colorIcono;
    final IconData icono;

    if (opcion.esNueva) {
      titulo = 'Crear etiqueta "#${opcion.nombre}"';
      detalle = 'Se asignará a esta nota';
      fondoIcono = AppColors.successBg;
      colorIcono = AppColors.success;
      icono = Icons.add_rounded;
    } else {
      final colores = AppColors.tagColors(opcion.etiqueta!.colorIndex);
      titulo = '#${opcion.nombre}';
      detalle = cantidadNotas == null
          ? null
          : cantidadNotas == 0
              ? 'Sin notas'
              : 'Usada en ${textoNotas(cantidadNotas!)}';
      fondoIcono = colores.bg;
      colorIcono = colores.text;
      icono = Icons.local_offer_outlined;
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: fondoIcono,
                borderRadius: AppRadius.tag,
              ),
              child: Icon(icono, size: 18, color: colorIcono),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.labelMd
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  if (detalle != null)
                    Text(
                      detalle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySm,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
