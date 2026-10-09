class Proyecto {
  final String id;
  final String nombre;
  final String descripcion;
  final DateTime fechaCreacion;
  final DateTime fechaModificacion;

  const Proyecto({
    required this.id,
    required this.nombre,
    this.descripcion = '',
    required this.fechaCreacion,
    required this.fechaModificacion,
  });

  Proyecto copyWith({
    String? nombre,
    String? descripcion,
    DateTime? fechaModificacion,
  }) {
    return Proyecto(
      id: id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      fechaCreacion: fechaCreacion,
      fechaModificacion: fechaModificacion ?? this.fechaModificacion,
    );
  }
}