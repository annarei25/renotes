const List<String> _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

String _dosDigitos(int numero) => numero.toString().padLeft(2, '0');

String _hora(DateTime fecha) =>
    '${_dosDigitos(fecha.hour)}:${_dosDigitos(fecha.minute)}';

/// "hoy, 14:30", "ayer", "hace 3 días", "12 oct" o "12 oct 2024".
/// Se usa en las listas, normalmente después de la palabra "Modificado".
String fechaRelativa(DateTime fecha, {DateTime? ahora}) {
  final hoy = ahora ?? DateTime.now();
  // Se compara solo el día (en UTC para que el cambio de hora no afecte).
  final dias = DateTime.utc(hoy.year, hoy.month, hoy.day)
      .difference(DateTime.utc(fecha.year, fecha.month, fecha.day))
      .inDays;

  if (dias == 0) return 'hoy, ${_hora(fecha)}';
  if (dias == 1) return 'ayer';
  if (dias > 1 && dias < 7) return 'hace $dias días';

  final base = '${fecha.day} ${_meses[fecha.month - 1]}';
  return fecha.year == hoy.year ? base : '$base ${fecha.year}';
}

/// "10 oct 2024, 14:30". Se usa en el Detalle de nota.
String fechaCompleta(DateTime fecha) {
  return '${fecha.day} ${_meses[fecha.month - 1]} ${fecha.year}, ${_hora(fecha)}';
}

/// "1 nota" o "6 notas".
String textoNotas(int cantidad) => cantidad == 1 ? '1 nota' : '$cantidad notas';

/// Descripción en una sola línea, para mostrarla como extracto en las listas.
String extracto(String texto, {int maxCaracteres = 160}) {
  final plano = texto.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (plano.length <= maxCaracteres) return plano;
  return '${plano.substring(0, maxCaracteres).trimRight()}…';
}
