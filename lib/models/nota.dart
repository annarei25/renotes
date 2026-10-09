class Nota {
  final String id;
  final String proyectoId;
  final String titulo;
  final String descripcion; // puede estar vacía
  final List<String> etiquetaIds;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  const Nota({
    required this.id,
    required this.proyectoId,
    required this.titulo,
    this.descripcion = '',
    this.etiquetaIds = const [],
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  Nota copyWith({
    String? titulo,
    String? descripcion,
    List<String>? etiquetaIds,
    DateTime? fechaModificacion,
  }) {
    return Nota(
      id: id,
      proyectoId: proyectoId,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      etiquetaIds: etiquetaIds ?? this.etiquetaIds,
      fechaCreacion: fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
    );
  }
}