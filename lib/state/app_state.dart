import 'package:flutter/widgets.dart';

import '../data/datos_prueba.dart';
import '../models/etiqueta.dart';
import '../models/nota.dart';
import '../models/proyecto.dart';

/// Modo de combinación al filtrar por varias etiquetas.
enum ModoFiltro { todas, alMenosUna }

/// Texto y filtros de una lista de notas.
class FiltrosNotas {
  String texto = '';
  String? proyectoId;
  final Set<String> etiquetaIds = {};
  ModoFiltro modo = ModoFiltro.todas;

  bool get activo =>
      texto.trim().isNotEmpty || proyectoId != null || etiquetaIds.isNotEmpty;

  void limpiar() {
    texto = '';
    proyectoId = null;
    etiquetaIds.clear();
    modo = ModoFiltro.todas;
  }
}

/// Copia de trabajo de la nota que se está creando o editando.
class BorradorNota {
  final String? notaId; // null = nota nueva
  final String proyectoId;
  final String _tituloOriginal;
  final String _descripcionOriginal;
  final List<String> _etiquetasOriginales;

  String titulo;
  String descripcion;
  List<String> etiquetaIds;

  BorradorNota.nueva(this.proyectoId)
      : notaId = null,
        titulo = '',
        descripcion = '',
        etiquetaIds = [],
        _tituloOriginal = '',
        _descripcionOriginal = '',
        _etiquetasOriginales = [];

  BorradorNota.desde(Nota nota)
      : notaId = nota.id,
        proyectoId = nota.proyectoId,
        titulo = nota.titulo,
        descripcion = nota.descripcion,
        etiquetaIds = List.of(nota.etiquetaIds),
        _tituloOriginal = nota.titulo,
        _descripcionOriginal = nota.descripcion,
        _etiquetasOriginales = List.of(nota.etiquetaIds);

  /// True si hay algo sin guardar (para el aviso al salir del editor).
  bool get hayCambios {
    if (titulo != _tituloOriginal || descripcion != _descripcionOriginal) {
      return true;
    }
    final actuales = Set.of(etiquetaIds);
    final originales = Set.of(_etiquetasOriginales);
    return actuales.length != originales.length ||
        !actuales.containsAll(originales);
  }
}

class AppState extends ChangeNotifier {
  AppState() {
    cargarDatosPrueba();
  }

  // ---------------------------------------------------------------------------
  // Datos
  // ---------------------------------------------------------------------------
  final List<Proyecto> _proyectos = [];
  final List<Nota> _notas = [];
  final List<Etiqueta> _etiquetas = [];

  int _contadorId = 0;

  // Cantidad de colores en la paleta de etiquetas (ver AppColors.tagPalette).
  static const int _coloresDeEtiqueta = 8;

  String _nuevoId(String prefijo) =>
      '$prefijo${DateTime.now().microsecondsSinceEpoch}_${_contadorId++}';

  void cargarDatosPrueba() {
    _proyectos
      ..clear()
      ..addAll(DatosPrueba.proyectos());
    _notas
      ..clear()
      ..addAll(DatosPrueba.notas());
    _etiquetas
      ..clear()
      ..addAll(DatosPrueba.etiquetas());
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Navegación y selección
  // ---------------------------------------------------------------------------
  int pestanaActual = 0; // 0 Proyectos, 1 Etiquetas, 2 Buscar
  String? proyectoAbiertoId;
  String? notaAbiertaId;

  void cambiarPestana(int indice) {
    pestanaActual = indice;
    notifyListeners();
  }

  /// Abre un proyecto y reinicia los filtros de su lista de notas.
  void abrirProyecto(String id) {
    proyectoAbiertoId = id;
    filtrosProyecto.limpiar();
    notifyListeners();
  }

  void abrirNota(String id) {
    notaAbiertaId = id;
    notifyListeners();
  }

  /// Detalle de nota -> Etiquetas filtrada por una etiqueta.
  void filtrarEtiquetasPor(String etiquetaId) {
    etiquetasSeleccionadas
      ..clear()
      ..add(etiquetaId);
    textoBusquedaEtiquetas = '';
    pestanaActual = 1;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Filtros de cada pestaña (se conservan al cambiar de pestaña)
  // ---------------------------------------------------------------------------

  // Notas del proyecto: usa texto y etiquetas (el proyecto es el abierto).
  final FiltrosNotas filtrosProyecto = FiltrosNotas();

  // Buscar: texto, proyecto y etiquetas.
  final FiltrosNotas filtrosBusqueda = FiltrosNotas();

  // Etiquetas: búsqueda por nombre, selección y modo.
  String textoBusquedaEtiquetas = '';
  final Set<String> etiquetasSeleccionadas = {};
  ModoFiltro modoEtiquetas = ModoFiltro.todas;

  void setTextoProyecto(String texto) {
    filtrosProyecto.texto = texto;
    notifyListeners();
  }

  void alternarEtiquetaProyecto(String etiquetaId) {
    _alternar(filtrosProyecto.etiquetaIds, etiquetaId);
    notifyListeners();
  }

  void limpiarEtiquetasProyecto() {
    filtrosProyecto.etiquetaIds.clear();
    notifyListeners();
  }

  void setTextoBusqueda(String texto) {
    filtrosBusqueda.texto = texto;
    notifyListeners();
  }

  void setProyectoBusqueda(String? proyectoId) {
    filtrosBusqueda.proyectoId = proyectoId;
    notifyListeners();
  }

  void alternarEtiquetaBusqueda(String etiquetaId) {
    _alternar(filtrosBusqueda.etiquetaIds, etiquetaId);
    notifyListeners();
  }

  void limpiarEtiquetasBusqueda() {
    filtrosBusqueda.etiquetaIds.clear();
    notifyListeners();
  }

  void limpiarFiltrosBusqueda() {
    filtrosBusqueda.limpiar();
    notifyListeners();
  }

  void setTextoBusquedaEtiquetas(String texto) {
    textoBusquedaEtiquetas = texto;
    notifyListeners();
  }

  void alternarEtiquetaSeleccionada(String etiquetaId) {
    _alternar(etiquetasSeleccionadas, etiquetaId);
    notifyListeners();
  }

  void setModoEtiquetas(ModoFiltro modo) {
    modoEtiquetas = modo;
    notifyListeners();
  }

  void limpiarSeleccionEtiquetas() {
    etiquetasSeleccionadas.clear();
    notifyListeners();
  }

  void _alternar(Set<String> conjunto, String id) {
    if (!conjunto.remove(id)) conjunto.add(id);
  }

  // ---------------------------------------------------------------------------
  // Consultas
  // ---------------------------------------------------------------------------

  /// Proyectos, el más reciente primero.
  List<Proyecto> get proyectos {
    final lista = List.of(_proyectos);
    lista.sort((a, b) => b.fechaModificacion.compareTo(a.fechaModificacion));
    return lista;
  }

  /// Etiquetas ordenadas por nombre.
  List<Etiqueta> get etiquetas {
    final lista = List.of(_etiquetas);
    lista.sort((a, b) => Etiqueta.normalizar(a.nombre)
        .compareTo(Etiqueta.normalizar(b.nombre)));
    return lista;
  }

  Proyecto? proyectoPorId(String? id) =>
      _proyectos.where((p) => p.id == id).firstOrNull;

  Nota? notaPorId(String? id) => _notas.where((n) => n.id == id).firstOrNull;

  Etiqueta? etiquetaPorId(String id) =>
      _etiquetas.where((e) => e.id == id).firstOrNull;

  Proyecto? get proyectoAbierto => proyectoPorId(proyectoAbiertoId);
  Nota? get notaAbierta => notaPorId(notaAbiertaId);

  /// Notas de un proyecto, la más reciente primero.
  List<Nota> notasDeProyecto(String proyectoId) {
    final lista = _notas.where((n) => n.proyectoId == proyectoId).toList();
    lista.sort((a, b) => b.fechaModificacion.compareTo(a.fechaModificacion));
    return lista;
  }

  int cantidadNotasProyecto(String proyectoId) =>
      _notas.where((n) => n.proyectoId == proyectoId).length;

  int cantidadNotasEtiqueta(String etiquetaId) =>
      _notas.where((n) => n.etiquetaIds.contains(etiquetaId)).length;

  /// Etiquetas de una nota (en el orden en que se asignaron).
  List<Etiqueta> etiquetasDeNota(Nota nota) {
    final resultado = <Etiqueta>[];
    for (final id in nota.etiquetaIds) {
      final etiqueta = etiquetaPorId(id);
      if (etiqueta != null) resultado.add(etiqueta);
    }
    return resultado;
  }

  /// Solo las etiquetas que aparecen en notas del proyecto (RF2).
  List<Etiqueta> etiquetasDelProyecto(String proyectoId) {
    final ids = <String>{};
    for (final nota in _notas.where((n) => n.proyectoId == proyectoId)) {
      ids.addAll(nota.etiquetaIds);
    }
    return etiquetas.where((e) => ids.contains(e.id)).toList();
  }

  /// Cuántas notas del proyecto tiene una etiqueta (para los chips de filtro).
  int cantidadNotasEtiquetaEnProyecto(String proyectoId, String etiquetaId) {
    return _notas
        .where((n) =>
            n.proyectoId == proyectoId && n.etiquetaIds.contains(etiquetaId))
        .length;
  }

  /// RF2: notas del proyecto abierto con búsqueda y filtro de etiquetas.
  List<Nota> get notasFiltradasProyecto {
    final id = proyectoAbiertoId;
    if (id == null) return [];
    return notasDeProyecto(id)
        .where((n) =>
            _coincideTexto(n, filtrosProyecto.texto) &&
            _coincideEtiquetas(
              n,
              filtrosProyecto.etiquetaIds,
              filtrosProyecto.modo,
            ))
        .toList();
  }

  /// RF6: búsqueda global con filtros opcionales de proyecto y etiquetas.
  List<Nota> get resultadosBusqueda {
    final f = filtrosBusqueda;
    final lista = _notas
        .where((n) =>
            (f.proyectoId == null || n.proyectoId == f.proyectoId) &&
            _coincideTexto(n, f.texto) &&
            _coincideEtiquetas(n, f.etiquetaIds, f.modo))
        .toList();
    lista.sort((a, b) => b.fechaModificacion.compareTo(a.fechaModificacion));
    return lista;
  }

  /// RF5: etiquetas que coinciden con el texto de búsqueda.
  List<Etiqueta> get etiquetasVisibles {
    final q = Etiqueta.normalizar(textoBusquedaEtiquetas);
    if (q.isEmpty) return etiquetas;
    return etiquetas
        .where((e) => Etiqueta.normalizar(e.nombre).contains(q))
        .toList();
  }

  /// RF5: notas de todos los proyectos según las etiquetas seleccionadas.
  /// Sin selección devuelve una lista vacía.
  List<Nota> get notasPorEtiquetasSeleccionadas {
    if (etiquetasSeleccionadas.isEmpty) return [];
    final lista = _notas
        .where((n) =>
            _coincideEtiquetas(n, etiquetasSeleccionadas, modoEtiquetas))
        .toList();
    lista.sort((a, b) => b.fechaModificacion.compareTo(a.fechaModificacion));
    return lista;
  }

  /// Coincidencia sin mayúsculas ni acentos, en título o contenido.
  bool _coincideTexto(Nota nota, String texto) {
    final q = Etiqueta.normalizar(texto);
    if (q.isEmpty) return true;
    return Etiqueta.normalizar(nota.titulo).contains(q) ||
        Etiqueta.normalizar(nota.descripcion).contains(q);
  }

  bool _coincideEtiquetas(Nota nota, Set<String> ids, ModoFiltro modo) {
    if (ids.isEmpty) return true;
    return modo == ModoFiltro.todas
        ? ids.every(nota.etiquetaIds.contains)
        : ids.any(nota.etiquetaIds.contains);
  }

  // ---------------------------------------------------------------------------
  // Proyectos (RF1)
  // ---------------------------------------------------------------------------

  /// Devuelve un mensaje de error, o null si todo salió bien.
  String? crearProyecto(String nombre, String descripcion) {
    if (nombre.trim().isEmpty) return 'El nombre del proyecto es obligatorio';
    final ahora = DateTime.now();
    _proyectos.add(Proyecto(
      id: _nuevoId('p'),
      nombre: nombre.trim(),
      descripcion: descripcion.trim(),
      fechaCreacion: ahora,
      fechaModificacion: ahora,
    ));
    _cambio();
    return null;
  }

  String? editarProyecto(String id, String nombre, String descripcion) {
    if (nombre.trim().isEmpty) return 'El nombre del proyecto es obligatorio';
    final i = _proyectos.indexWhere((p) => p.id == id);
    if (i == -1) return 'El proyecto no existe';
    _proyectos[i] = _proyectos[i].copyWith(
      nombre: nombre.trim(),
      descripcion: descripcion.trim(),
      fechaModificacion: DateTime.now(),
    );
    _cambio();
    return null;
  }

  /// Elimina el proyecto y sus notas. Las etiquetas no se eliminan.
  void eliminarProyecto(String id) {
    _proyectos.removeWhere((p) => p.id == id);
    _notas.removeWhere((n) => n.proyectoId == id);
    _cambio();
  }

  void _tocarProyecto(String proyectoId, DateTime fecha) {
    final i = _proyectos.indexWhere((p) => p.id == proyectoId);
    if (i != -1) {
      _proyectos[i] = _proyectos[i].copyWith(fechaModificacion: fecha);
    }
  }

  // ---------------------------------------------------------------------------
  // Notas (RF2, RF3, RF4)
  // ---------------------------------------------------------------------------

  void eliminarNota(String id) {
    final nota = notaPorId(id);
    if (nota == null) return;
    _notas.removeWhere((n) => n.id == id);
    _tocarProyecto(nota.proyectoId, DateTime.now());
    _cambio();
  }

  // ---------------------------------------------------------------------------
  // Borrador de la nota en edición (RF3)
  // ---------------------------------------------------------------------------
  BorradorNota? _borrador;
  BorradorNota? get borrador => _borrador;

  // Etiquetas creadas mientras se edita el borrador. Si el usuario cancela,
  // las que no quedaron en ninguna nota se eliminan.
  final Set<String> _etiquetasCreadasEnBorrador = {};

  /// Para editar una nota pasa [notaId]; para crear una nueva, [proyectoId].
  void iniciarBorrador({String? notaId, String? proyectoId}) {
    _etiquetasCreadasEnBorrador.clear();
    if (notaId != null) {
      final nota = notaPorId(notaId);
      if (nota == null) return;
      _borrador = BorradorNota.desde(nota);
    } else if (proyectoId != null) {
      _borrador = BorradorNota.nueva(proyectoId);
    }
    notifyListeners();
  }

  // Título y descripción no avisan a los widgets: así escribir un texto
  // largo no reconstruye todas las pantallas en cada tecla.
  void actualizarTituloBorrador(String titulo) => _borrador?.titulo = titulo;

  void actualizarDescripcionBorrador(String descripcion) =>
      _borrador?.descripcion = descripcion;

  /// Asigna una etiqueta existente (la que se toca en las sugerencias).
  void asignarEtiquetaAlBorrador(String etiquetaId) {
    final b = _borrador;
    if (b == null || b.etiquetaIds.contains(etiquetaId)) return;
    b.etiquetaIds.add(etiquetaId);
    notifyListeners();
  }

  /// Crea la etiqueta y la asigna en el mismo paso. Si el nombre ya existe,
  /// reutiliza la existente (nunca crea duplicados).
  void crearYAsignarEtiquetaAlBorrador(String nombre) {
    final b = _borrador;
    final limpio = _limpiarNombre(nombre);
    if (b == null || limpio.isEmpty) return;

    var etiqueta = buscarEtiquetaPorNombre(limpio);
    if (etiqueta == null) {
      etiqueta = _crearEtiquetaInterna(limpio);
      _etiquetasCreadasEnBorrador.add(etiqueta.id);
    }
    if (!b.etiquetaIds.contains(etiqueta.id)) b.etiquetaIds.add(etiqueta.id);
    notifyListeners();
  }

  void quitarEtiquetaDelBorrador(String etiquetaId) {
    _borrador?.etiquetaIds.remove(etiquetaId);
    notifyListeners();
  }

  /// Guarda el borrador (crea o actualiza la nota).
  /// Devuelve un mensaje de error, o null si todo salió bien.
  String? guardarBorrador() {
    final b = _borrador;
    if (b == null) return 'No hay una nota en edición';
    if (b.titulo.trim().isEmpty) return 'El título es obligatorio';

    final ahora = DateTime.now();
    if (b.notaId == null) {
      _notas.add(Nota(
        id: _nuevoId('n'),
        proyectoId: b.proyectoId,
        titulo: b.titulo.trim(),
        descripcion: b.descripcion,
        etiquetaIds: List.of(b.etiquetaIds),
        fechaCreacion: ahora,
        fechaModificacion: ahora,
      ));
    } else {
      final i = _notas.indexWhere((n) => n.id == b.notaId);
      if (i != -1) {
        _notas[i] = _notas[i].copyWith(
          titulo: b.titulo.trim(),
          descripcion: b.descripcion,
          etiquetaIds: List.of(b.etiquetaIds),
          fechaModificacion: ahora,
        );
      }
    }
    _tocarProyecto(b.proyectoId, ahora);
    _borrador = null;
    _limpiarEtiquetasHuerfanasDelBorrador();
    _cambio();
    return null;
  }

  /// Descarta el borrador (Cancelar o salir sin guardar).
  void descartarBorrador() {
    _borrador = null;
    _limpiarEtiquetasHuerfanasDelBorrador();
    _cambio();
  }

  void _limpiarEtiquetasHuerfanasDelBorrador() {
    for (final id in _etiquetasCreadasEnBorrador) {
      if (cantidadNotasEtiqueta(id) == 0) {
        _etiquetas.removeWhere((e) => e.id == id);
      }
    }
    _etiquetasCreadasEnBorrador.clear();
  }

  // ---------------------------------------------------------------------------
  // Etiquetas (RF3, RF5)
  // ---------------------------------------------------------------------------

  /// Quita espacios y los # del inicio ("#Método" -> "Método").
  String _limpiarNombre(String nombre) {
    var limpio = nombre.trim();
    while (limpio.startsWith('#')) {
      limpio = limpio.substring(1).trim();
    }
    return limpio;
  }

  /// Busca por nombre sin distinguir mayúsculas, acentos ni espacios extremos.
  Etiqueta? buscarEtiquetaPorNombre(String nombre) {
    final q = Etiqueta.normalizar(_limpiarNombre(nombre));
    if (q.isEmpty) return null;
    return _etiquetas
        .where((e) => Etiqueta.normalizar(e.nombre) == q)
        .firstOrNull;
  }

  Etiqueta _crearEtiquetaInterna(String nombre) {
    final etiqueta = Etiqueta(
      id: _nuevoId('e'),
      nombre: nombre,
      colorIndex: _etiquetas.length % _coloresDeEtiqueta,
    );
    _etiquetas.add(etiqueta);
    return etiqueta;
  }

  /// Sugerencias del autocompletado: coinciden en cualquier parte del nombre
  /// y no incluyen las que la nota ya tiene asignadas.
  List<Etiqueta> sugerenciasEtiquetas(String texto, List<String> excluidas) {
    final q = Etiqueta.normalizar(_limpiarNombre(texto));
    if (q.isEmpty) return [];
    return etiquetas
        .where((e) =>
            !excluidas.contains(e.id) &&
            Etiqueta.normalizar(e.nombre).contains(q))
        .toList();
  }

  /// Crea una etiqueta independiente de cualquier nota.
  /// Devuelve un mensaje de error, o null si todo salió bien.
  String? crearEtiqueta(String nombre) {
    final limpio = _limpiarNombre(nombre);
    if (limpio.isEmpty) return 'El nombre de la etiqueta es obligatorio';
    if (buscarEtiquetaPorNombre(limpio) != null) {
      return 'Ya existe una etiqueta con ese nombre';
    }
    _crearEtiquetaInterna(limpio);
    _cambio();
    return null;
  }

  /// Renombra una etiqueta; el cambio se ve en todas las notas que la usan.
  /// Devuelve un mensaje de error, o null si todo salió bien.
  String? renombrarEtiqueta(String id, String nuevoNombre) {
    final limpio = _limpiarNombre(nuevoNombre);
    if (limpio.isEmpty) return 'El nombre de la etiqueta es obligatorio';

    final existente = buscarEtiquetaPorNombre(limpio);
    if (existente != null && existente.id != id) {
      return 'Ya existe una etiqueta con ese nombre';
    }
    final i = _etiquetas.indexWhere((e) => e.id == id);
    if (i == -1) return 'La etiqueta no existe';
    _etiquetas[i] = _etiquetas[i].copyWith(nombre: limpio);
    _cambio();
    return null;
  }

  /// Elimina la etiqueta y la quita de todas las notas. Las notas no se borran.
  void eliminarEtiqueta(String id) {
    _etiquetas.removeWhere((e) => e.id == id);
    for (var i = 0; i < _notas.length; i++) {
      if (_notas[i].etiquetaIds.contains(id)) {
        _notas[i] = _notas[i].copyWith(
          etiquetaIds: _notas[i].etiquetaIds.where((e) => e != id).toList(),
        );
      }
    }
    _borrador?.etiquetaIds.remove(id);
    _cambio();
  }

  // ---------------------------------------------------------------------------
  // Mantenimiento
  // ---------------------------------------------------------------------------

  /// Quita de los filtros y selecciones lo que ya no existe y avisa a las
  /// pantallas. Se llama después de cada cambio en los datos.
  void _cambio() {
    final idsEtiquetas = _etiquetas.map((e) => e.id).toSet();
    etiquetasSeleccionadas.removeWhere((id) => !idsEtiquetas.contains(id));
    filtrosBusqueda.etiquetaIds.removeWhere((id) => !idsEtiquetas.contains(id));

    if (filtrosBusqueda.proyectoId != null &&
        proyectoPorId(filtrosBusqueda.proyectoId) == null) {
      filtrosBusqueda.proyectoId = null;
    }
    if (proyectoAbiertoId != null && proyectoAbierto == null) {
      proyectoAbiertoId = null;
    }
    if (notaAbiertaId != null && notaAbierta == null) {
      notaAbiertaId = null;
    }

    // En Notas del proyecto solo valen etiquetas presentes en ese proyecto.
    final abierto = proyectoAbiertoId;
    if (abierto == null) {
      filtrosProyecto.etiquetaIds.clear();
    } else {
      final presentes =
          etiquetasDelProyecto(abierto).map((e) => e.id).toSet();
      filtrosProyecto.etiquetaIds.removeWhere((id) => !presentes.contains(id));
    }

    notifyListeners();
  }
}

/// Entrega el AppState a todo el árbol de widgets (equivale a un Provider,
/// pero usando solo el SDK de Flutter).
class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  /// Devuelve el estado y reconstruye el widget cuando cambia.
  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No hay un AppStateScope sobre este widget');
    return scope!.notifier!;
  }

  /// Devuelve el estado sin reconstruir (para botones y callbacks).
  static AppState leer(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'No hay un AppStateScope sobre este widget');
    return scope!.notifier!;
  }
}
