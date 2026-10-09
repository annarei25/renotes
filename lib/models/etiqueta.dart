class Etiqueta {
  final String id;
  final String nombre;
  final int? colorIndex; // opcional: posición en la paleta de 8 colores

  const Etiqueta({
    required this.id,
    required this.nombre,
    this.colorIndex,
  });

  Etiqueta copyWith({String? nombre}) {
    return Etiqueta(id: id, nombre: nombre ?? this.nombre, colorIndex: colorIndex);
  }

  /// Minúsculas, sin acentos y sin espacios en los extremos.
  static String normalizar(String texto) {
    const conAcento = 'áàäâéèëêíìïîóòöôúùüûñ';
    const sinAcento = 'aaaaeeeeiiiioooouuuun';
    var resultado = texto.trim().toLowerCase();
    for (var i = 0; i < conAcento.length; i++) {
      resultado = resultado.replaceAll(conAcento[i], sinAcento[i]);
    }
    return resultado;
  }
}