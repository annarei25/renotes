import '../models/etiqueta.dart';
import '../models/nota.dart';
import '../models/proyecto.dart';

/// Datos de prueba que se cargan en memoria al iniciar la app.
/// Cada método devuelve una lista nueva, así AppState puede modificarla.
class DatosPrueba {
  DatosPrueba._();

  static final DateTime _ahora = DateTime.now();

  static DateTime _hace({int dias = 0, int horas = 0, int minutos = 0}) {
    return _ahora.subtract(
      Duration(days: dias, hours: horas, minutes: minutos),
    );
  }

  static List<Etiqueta> etiquetas() {
    return const [
      Etiqueta(id: 'e1', nombre: 'Metodología', colorIndex: 6),
      Etiqueta(id: 'e2', nombre: 'Entrevistas', colorIndex: 0),
      Etiqueta(id: 'e3', nombre: 'Bibliografía', colorIndex: 2),
      Etiqueta(id: 'e4', nombre: 'IA-Generativa', colorIndex: 3),
      Etiqueta(id: 'e5', nombre: 'Pedagogía', colorIndex: 4),
      Etiqueta(id: 'e6', nombre: 'Sistemas', colorIndex: 5),
      Etiqueta(id: 'e7', nombre: 'Energía', colorIndex: 1),
      Etiqueta(id: 'e8', nombre: 'SinAsignar'),
    ];
  }

  static List<Proyecto> proyectos() {
    return [
      Proyecto(
        id: 'p1',
        nombre: 'Impacto de la IA en la Educación Superior',
        descripcion:
        'Estudio cualitativo y cuantitativo sobre adopción de herramientas '
        'generativas en estudiantes de grado y posgrado.',
        fechaCreacion: _hace(dias: 60),
        fechaModificacion: _hace(minutos: 10),
      ),
      Proyecto(
        id: 'p2',
        nombre: 'Transición Energética y Redes Inteligentes',
        descripcion:
        'Análisis de viabilidad técnica y regulatoria para micro-redes solares '
        'comunitarias en zonas rurales.',
        fechaCreacion: _hace(dias: 45),
        fechaModificacion: _hace(dias: 2),
      ),
      Proyecto(
        id: 'p3',
        nombre: 'Diseño de Sistemas Distribuidos',
        descripcion:
        'Patrones de arquitectura orientada a eventos, tolerancia a fallos y '
        'consistencia eventual en servicios.',
        fechaCreacion: _hace(dias: 30),
        fechaModificacion: _hace(horas: 3),
      ),
    ];
  }

  static List<Nota> notas() {
    return [
      Nota(
        id: 'n01',
        proyectoId: 'p1',
        titulo: 'Entrevistas a Docentes de Ciencias Exactas',
        etiquetaIds: ['e2', 'e1'],
        fechaCreacion: _hace(dias: 20),
        fechaModificacion: _hace(minutos: 30),
        descripcion:
        'Los docentes reportan una ambivalencia marcada entre el ahorro de '
        'tiempo en la preparación de materiales y la preocupación por la '
        'pérdida de autonomía intelectual de los estudiantes. Se realizaron 12 '
        'entrevistas semiestructuradas de entre 40 y 55 minutos, grabadas con '
        'consentimiento y transcritas de forma literal.\n\nLa codificación '
        'inicial identificó cuatro temas recurrentes: eficiencia, confianza en '
        'la herramienta, evaluación auténtica e integridad académica. Varios '
        'profesores señalaron que los ejercicios tradicionales de cálculo ya no '
        'permiten distinguir el trabajo propio del asistido, y que deben '
        'rediseñar las evaluaciones hacia la defensa oral y la resolución de '
        'problemas abiertos.\n\nPendiente: triangular estos hallazgos con los '
        'resultados de la encuesta a estudiantes y contrastar la muestra con '
        'docentes de humanidades para comprobar si la ambivalencia es '
        'específica de las ciencias exactas.',
      ),
      Nota(
        id: 'n02',
        proyectoId: 'p1',
        titulo: 'Revisión Sistemática: Prompt Engineering en Pedagogía',
        etiquetaIds: ['e3', 'e4'],
        fechaCreacion: _hace(dias: 41),
        fechaModificacion: _hace(dias: 1),
        descripcion:
        'Se evaluaron 42 artículos indexados en Scopus y Web of Science entre '
        '2023 y 2024 sobre marcos pedagógicos asistidos por modelos de '
        'lenguaje. La búsqueda combinó los términos prompt engineering, '
        'educación superior y aprendizaje asistido, con filtros por revisión '
        'por pares y acceso al texto completo.\n\nCriterios de inclusión: '
        'estudios empíricos con participantes reales, descripción explícita de '
        'la intervención y alguna medida de aprendizaje. Se excluyeron las '
        'opiniones, los informes técnicos sin metodología y los trabajos '
        'centrados solo en la enseñanza de programación.\n\nResultado '
        'preliminar: la mayoría de los estudios reporta mejoras en la '
        'percepción de aprendizaje, pero pocos miden retención a mediano plazo. '
        'Solo 9 artículos incluyen grupo de control. Se propone una tabla de '
        'extracción con diseño, muestra, intervención, instrumentos y '
        'limitaciones declaradas.',
      ),
      Nota(
        id: 'n03',
        proyectoId: 'p1',
        titulo: 'Hipótesis sobre Retención Conceptual',
        etiquetaIds: ['e1'],
        fechaCreacion: _hace(dias: 65),
        fechaModificacion: _hace(dias: 10),
        descripcion:
        'La dependencia temprana de resúmenes sintéticos podría afectar la '
        'retención conceptual a largo plazo. Hipótesis nula: no hay diferencia '
        'en la retención a 4 semanas entre quienes estudian con resúmenes '
        'automáticos y quienes elaboran los suyos.',
      ),
      Nota(
        id: 'n04',
        proyectoId: 'p1',
        titulo: 'Análisis Preliminar de Encuestas a Estudiantes',
        etiquetaIds: ['e1', 'e2', 'e5'],
        fechaCreacion: _hace(dias: 10),
        fechaModificacion: _hace(minutos: 10),
        descripcion:
        'Se encuestaron 180 estudiantes de segundo y tercer año universitario '
        'sobre la frecuencia de uso de modelos de lenguaje en tareas de '
        'redacción y comprensión lectora. Los resultados preliminares muestran '
        'que el 78% utiliza asistentes de IA al menos 3 veces por semana, '
        'principalmente para sintetizar lecturas densas y depurar código en '
        'asignaturas prácticas.\n\nEn cuanto a la percepción de aprendizaje, un '
        '64% afirma que la herramienta les permite avanzar más rápido con '
        'borradores iniciales, aunque el 42% reconoce dificultades al defender '
        'verbalmente conceptos complejos sin apoyo de sus notas sintéticas '
        'generadas automáticamente.\n\nExiste una brecha creciente entre la '
        'velocidad de producción textual y la asimilación conceptual autónoma '
        'en evaluaciones orales.\n\nRecomendaciones preliminares para la fase 2 '
        'del estudio: diseñar rúbricas de evaluación oral y requerir bitácoras '
        'de prompts en entregables académicos de investigación.',
      ),
      Nota(
        id: 'n05',
        proyectoId: 'p1',
        titulo: 'Matriz de Síntesis Teórica y Rúbricas',
        etiquetaIds: ['e1', 'e3'],
        fechaCreacion: _hace(dias: 39),
        fechaModificacion: _hace(dias: 4),
        descripcion:
        'Comparativa cualitativa entre rúbricas estandarizadas y '
        'retroalimentación continua. Columnas: autor, año, marco teórico, tipo '
        'de rúbrica, efecto reportado y limitaciones.',
      ),
      Nota(
        id: 'n06',
        proyectoId: 'p1',
        titulo: 'Notas de la reunión con el tutor',
        etiquetaIds: [],
        fechaCreacion: _hace(dias: 4),
        fechaModificacion: _hace(dias: 2),
        descripcion:
        'Revisar el alcance de la fase 2 y reducir la muestra de docentes. '
        'Enviar el borrador del marco teórico antes del viernes.',
      ),
      Nota(
        id: 'n07',
        proyectoId: 'p2',
        titulo: 'Validación de Entrevistas con Expertos de Red Eléctrica',
        etiquetaIds: ['e1', 'e2', 'e7'],
        fechaCreacion: _hace(dias: 32),
        fechaModificacion: _hace(dias: 2),
        descripcion:
        'Hallazgos de campo sobre protocolos de integración fotovoltaica '
        'distribuida, contrastando las respuestas de seis ingenieros de '
        'operación de redes de distribución con la normativa vigente. Los '
        'entrevistados coinciden en que el principal cuello de botella no es la '
        'generación, sino la capacidad de los transformadores existentes para '
        'absorber inyecciones bidireccionales.\n\nSe identificaron tres tipos '
        'de restricciones: técnicas (niveles de tensión y protecciones), '
        'administrativas (plazos de autorización) y económicas (costo de '
        'refuerzo de la red a cargo del productor). Dos expertos mencionaron '
        'experiencias previas con micro-redes que debieron desconectarse por '
        'falta de criterios claros de aislamiento ante fallas.\n\nLa validación '
        'se hizo enviando a cada entrevistado un resumen de dos páginas para '
        'que corrigiera o ampliara sus declaraciones. Cuatro de seis '
        'respondieron y ninguno retiró citas, aunque uno pidió anonimizar la '
        'empresa.',
      ),
      Nota(
        id: 'n08',
        proyectoId: 'p2',
        titulo: 'Viabilidad regulatoria de micro-redes comunitarias',
        etiquetaIds: ['e7', 'e3'],
        fechaCreacion: _hace(dias: 30),
        fechaModificacion: _hace(dias: 5),
        descripcion:
        'Revisión del marco regulatorio aplicable a micro-redes solares '
        'comunitarias en zonas rurales. Se analizaron la ley de energías '
        'renovables, el reglamento de conexión a red y tres resoluciones '
        'sectoriales recientes sobre autoconsumo colectivo y venta de '
        'excedentes.\n\nConclusión parcial: la normativa permite el autoconsumo '
        'individual, pero no define con claridad la figura de comunidad '
        'energética, lo que impide repartir la producción entre varios usuarios '
        'sin pasar por un comercializador. Esto encarece el modelo y desalienta '
        'a las cooperativas pequeñas.\n\nFuentes consultadas: informes de '
        'organismos reguladores, documentos de consulta pública, artículos '
        'académicos sobre comunidades energéticas en Europa y dos estudios de '
        'caso en América Latina. Falta contrastar las cifras de tarifas con '
        'datos oficiales actualizados y revisar si existen proyectos piloto '
        'exentos de ciertas obligaciones.',
      ),
      Nota(
        id: 'n09',
        proyectoId: 'p2',
        titulo: 'Interoperabilidad de medidores inteligentes',
        etiquetaIds: ['e7', 'e6'],
        fechaCreacion: _hace(dias: 32),
        fechaModificacion: _hace(dias: 12),
        descripcion:
        'Recopilación de testimonios sobre interoperabilidad de medidores '
        'inteligentes y protocolos de comunicación abiertos frente a soluciones '
        'propietarias.',
      ),
      Nota(
        id: 'n10',
        proyectoId: 'p2',
        titulo: 'Matriz de Codificación Temática: Sesiones de Grupo Focal',
        etiquetaIds: ['e1', 'e2'],
        fechaCreacion: _hace(dias: 25),
        fechaModificacion: _hace(dias: 7),
        descripcion:
        'Estructura de categorización axial de testimonios de usuarios y '
        'técnicos para triangular la fiabilidad de los hallazgos entre '
        'sesiones.',
      ),
      Nota(
        id: 'n11',
        proyectoId: 'p2',
        titulo: 'Costos de instalación solar comunitaria',
        etiquetaIds: ['e7'],
        fechaCreacion: _hace(dias: 35),
        fechaModificacion: _hace(dias: 20),
        descripcion:
        'Estimación preliminar de costos por kilovatio instalado, mantenimiento '
        'anual y retorno de la inversión para tres escenarios de tamaño de '
        'comunidad.',
      ),
      Nota(
        id: 'n12',
        proyectoId: 'p3',
        titulo: 'Patrones de arquitectura orientada a eventos',
        etiquetaIds: ['e6', 'e3'],
        fechaCreacion: _hace(dias: 28),
        fechaModificacion: _hace(horas: 3),
        descripcion:
        'Resumen de los patrones principales para sistemas orientados a '
        'eventos: event notification, event-carried state transfer, event '
        'sourcing y CQRS. Cada patrón se evalúa según el acoplamiento que '
        'introduce, la facilidad de auditoría y la complejidad operativa que '
        'añade al equipo.\n\nEvent sourcing guarda cada cambio como un evento '
        'inmutable y reconstruye el estado reproduciendo la secuencia. Ofrece '
        'trazabilidad completa y facilita depurar errores en producción, pero '
        'obliga a versionar los esquemas de eventos y a manejar con cuidado las '
        'proyecciones que se rehacen.\n\nCQRS separa el modelo de escritura del '
        'de lectura. Se recomienda solo cuando las consultas tienen requisitos '
        'muy distintos a las escrituras, porque duplica componentes y añade '
        'latencia de propagación entre ambos modelos.\n\nLecturas pendientes: '
        'capítulos sobre mensajería en el libro de patrones de integración '
        'empresarial y dos artículos sobre migración gradual desde un monolito.',
      ),
      Nota(
        id: 'n13',
        proyectoId: 'p3',
        titulo: 'Consistencia eventual y resolución de conflictos',
        etiquetaIds: ['e6', 'e1'],
        fechaCreacion: _hace(dias: 25),
        fechaModificacion: _hace(dias: 3),
        descripcion:
        'Análisis de estrategias para resolver conflictos cuando varias '
        'réplicas aceptan escrituras concurrentes. Se comparan last-write-wins, '
        'vectores de versión y tipos de datos replicados sin conflicto, '
        'valorando la pérdida potencial de datos, el costo de almacenamiento y '
        'la complejidad para quien desarrolla.\n\nLast-write-wins es simple, '
        'pero descarta escrituras válidas cuando los relojes de los nodos no '
        'están sincronizados. Los vectores de versión detectan la concurrencia '
        'real, aunque delegan la decisión final en la aplicación. Los tipos '
        'replicados sin conflicto garantizan convergencia, a cambio de limitar '
        'las operaciones permitidas.\n\nMetodología propuesta: construir un '
        'banco de pruebas con tres nodos simulados, inyectar particiones de red '
        'de duración variable y medir la divergencia máxima y el tiempo hasta '
        'converger. Cada estrategia se probará con las mismas cargas de trabajo '
        'para poder comparar los resultados.',
      ),
      Nota(
        id: 'n14',
        proyectoId: 'p3',
        titulo: 'Tolerancia a fallos: casos de estudio',
        etiquetaIds: ['e6'],
        fechaCreacion: _hace(dias: 21),
        fechaModificacion: _hace(dias: 9),
        descripcion:
        'Tres casos públicos de caídas en cascada y las medidas que cada equipo '
        'adoptó después: tiempos de espera, cortacircuitos y degradación '
        'controlada.',
      ),
      Nota(
        id: 'n15',
        proyectoId: 'p3',
        titulo: 'Pruebas de carga del bus de eventos',
        etiquetaIds: ['e6', 'e1'],
        fechaCreacion: _hace(dias: 22),
        fechaModificacion: _hace(dias: 14),
        descripcion:
        'Plan de pruebas con tasas crecientes de mensajes por segundo. '
        'Métricas: latencia p95, mensajes perdidos y tiempo de recuperación '
        'tras reiniciar un consumidor.',
      ),
    ];
  }
}
