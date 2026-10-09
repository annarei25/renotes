import 'package:flutter/material.dart';

/// Campo de búsqueda con icono de lupa y botón para limpiar el texto.
/// Se usa en Notas del proyecto, Etiquetas y Buscar.
///
/// [valorInicial] permite recuperar el texto guardado en AppState cuando la
/// pantalla se vuelve a crear.
class CampoBusqueda extends StatefulWidget {
  final String valorInicial;
  final String hint;
  final ValueChanged<String> onChanged;

  const CampoBusqueda({
    super.key,
    this.valorInicial = '',
    required this.hint,
    required this.onChanged,
  });

  @override
  State<CampoBusqueda> createState() => _CampoBusquedaState();
}

class _CampoBusquedaState extends State<CampoBusqueda> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.valorInicial);

  @override
  void didUpdateWidget(CampoBusqueda anterior) {
    super.didUpdateWidget(anterior);
    // Si AppState cambió el texto por otra vía, el campo lo refleja.
    if (widget.valorInicial != anterior.valorInicial &&
        widget.valorInicial != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.valorInicial,
        selection: TextSelection.collapsed(offset: widget.valorInicial.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _limpiar() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _controller,
          builder: (context, valor, _) {
            if (valor.text.isEmpty) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Limpiar',
              icon: const Icon(Icons.close_rounded),
              onPressed: _limpiar,
            );
          },
        ),
      ),
    );
  }
}
