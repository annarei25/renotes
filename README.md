# ReNotes

App móvil en Flutter para organizar notas de investigación por **proyectos** y **etiquetas**.

Los datos viven en memoria mientras la app está abierta y se cargan desde datos de prueba al iniciar. La app usa solo el SDK de Flutter: no tiene paquetes externos.

## Capturas

| Proyectos | Notas del proyecto | Editor de nota |
|---|---|---|
| ![Proyectos](docs/capturas/01-proyectos.png) | ![Notas del proyecto](docs/capturas/02-notas-proyecto.png) | ![Editor de nota](docs/capturas/03-editor-nota.png) |

| Autocompletado de etiquetas | Detalle de nota | Etiquetas | Buscar |
|---|---|---|---|
| ![Autocompletado](docs/capturas/04-autocompletado.png) | ![Detalle de nota](docs/capturas/05-detalle-nota.png) | ![Etiquetas](docs/capturas/06-etiquetas.png) | ![Buscar](docs/capturas/07-buscar.png) |

## Qué permite hacer

- **Proyectos:** crear, editar y eliminar proyectos. Al eliminar uno se eliminan sus notas; las etiquetas se conservan.
- **Notas:** crear, editar y eliminar notas con título, descripción larga y etiquetas. Buscar dentro del proyecto por título o contenido y filtrar por una o varias etiquetas.
- **Editor con autocompletado:** al escribir una etiqueta sugiere las existentes (de cualquier proyecto), sin distinguir mayúsculas ni acentos, y ofrece crearla si no existe. También confirma con Enter o con una coma. No permite etiquetas duplicadas.
- **Etiquetas:** crear, renombrar y eliminar. El cambio se refleja en todas las notas. Se pueden elegir varias etiquetas para ver las notas de todos los proyectos que tienen **todas** o **al menos una**.
- **Búsqueda global:** por título o contenido en todos los proyectos, con filtro opcional por proyecto y por etiquetas.
- **Navegación con pestañas:** Proyectos, Etiquetas y Buscar. Cada pestaña conserva su texto de búsqueda, filtros y posición de scroll.
- **Aviso de cambios sin guardar** al salir del editor.

## Requisitos

- Flutter 3.27 o superior (el código usa `CardThemeData`, `DialogThemeData`, `withValues` y `PopScope.onPopInvokedWithResult`).
- Plataforma objetivo: Android.

## Cómo ejecutarlo

**1. Fuentes.** La app usa Plus Jakarta Sans (títulos) e Inter (textos). Descarga los archivos `.ttf` de Google Fonts y colócalos en `assets/fonts/`:

```
assets/fonts/PlusJakartaSans-Medium.ttf
assets/fonts/PlusJakartaSans-SemiBold.ttf
assets/fonts/PlusJakartaSans-Bold.ttf
assets/fonts/Inter-Regular.ttf
```

Se incluyen como archivos del proyecto, y no con el paquete `google_fonts`, porque ese paquete descarga y guarda las fuentes en el teléfono.

**2. `pubspec.yaml`.** Declara las fuentes:

```yaml
flutter:
  uses-material-design: true
  fonts:
    - family: PlusJakartaSans
      fonts:
        - asset: assets/fonts/PlusJakartaSans-Medium.ttf
          weight: 500
        - asset: assets/fonts/PlusJakartaSans-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/PlusJakartaSans-Bold.ttf
          weight: 700
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
          weight: 400
```

**3. Ejecutar:**

```
flutter pub get
flutter run
```

## Estructura del proyecto

```
lib/
├── main.dart
├── models/        Proyecto, Nota, Etiqueta
├── data/          Datos de prueba cargados al iniciar
├── state/         AppState: datos, lógica y filtros
├── routes/        Nombres de ruta y funciones de navegación
├── theme/         Colores, tipografías, medidas y tema
├── utils/         Formato de fechas y textos
├── screens/       Las pantallas
└── widgets/       Piezas reutilizables
```

<details>
<summary>Ver todos los archivos</summary>

```
lib/
├── main.dart
├── models/
│   ├── etiqueta.dart
│   ├── nota.dart
│   └── proyecto.dart
├── data/
│   └── datos_prueba.dart
├── state/
│   └── app_state.dart
├── routes/
│   └── app_routes.dart
├── theme/
│   ├── app_colors.dart
│   ├── app_text_styles.dart
│   ├── app_dimensions.dart
│   └── app_theme.dart
├── utils/
│   └── formato.dart
├── screens/
│   ├── inicio_screen.dart
│   ├── proyectos_screen.dart
│   ├── notas_proyecto_screen.dart
│   ├── detalle_nota_screen.dart
│   ├── editor_nota_screen.dart
│   ├── etiquetas_screen.dart
│   └── buscar_screen.dart
└── widgets/
    ├── app_tab_bar.dart
    ├── campo_busqueda.dart
    ├── confirm_dialog.dart
    ├── empty_state.dart
    ├── etiqueta_form_dialog.dart
    ├── note_card.dart
    ├── project_card.dart
    ├── proyecto_form_dialog.dart
    ├── tag_autocomplete_field.dart
    ├── tag_chip.dart
    ├── tag_filter_bar.dart
    └── tag_wrap.dart
```

</details>

## Pantallas

| Pantalla | Archivo | Requisito |
|---|---|---|
| Proyectos | `screens/proyectos_screen.dart` | RF1 |
| Notas del proyecto | `screens/notas_proyecto_screen.dart` | RF2 |
| Editor de nota | `screens/editor_nota_screen.dart` | RF3 |
| Detalle de nota | `screens/detalle_nota_screen.dart` | RF4 |
| Etiquetas | `screens/etiquetas_screen.dart` | RF5 |
| Buscar | `screens/buscar_screen.dart` | RF6 |
| Pestañas (`BottomNavigationBar`) | `screens/inicio_screen.dart` | RF7 |

## Cómo está construida

### Estado

Todo el estado está en `AppState` (`state/app_state.dart`), que extiende `ChangeNotifier`. Guarda las listas de proyectos, notas y etiquetas, los filtros de cada pestaña, el proyecto y la nota abiertos, y el borrador de la nota en edición.

Las pantallas no modifican los datos directamente: llaman a un método de `AppState` (por ejemplo `eliminarNota`), que hace el cambio y avisa con `notifyListeners()`. Las pantallas que están escuchando se redibujan solas.

`AppStateScope` (un `InheritedNotifier`) entrega el `AppState` a todo el árbol de widgets. Es el reemplazo de Provider usando solo el SDK:

```dart
AppStateScope.of(context)     // muestra datos y se redibuja cuando cambian
AppStateScope.leer(context)   // ejecuta una acción sin suscribirse
```

### Navegación

Se usa un solo método de navegación: `Navigator.pushNamed` (y `pop` para volver). Las rutas y las funciones para navegar están en `routes/app_routes.dart`. Las pantallas no reciben argumentos: antes de navegar se prepara `AppState` (proyecto abierto, nota abierta o borrador) y la pantalla lee de ahí.

Las tres pestañas están en un `IndexedStack`, que las mantiene creadas y por eso conservan su estado.

### Decisiones técnicas

| Decisión | Motivo |
|---|---|
| Las notas guardan los **IDs** de sus etiquetas | Renombrar o eliminar una etiqueta se refleja en todas las notas sin tocarlas |
| Modelos inmutables con `copyWith` | Evita cambios accidentales |
| Cantidades calculadas, no guardadas | Nunca quedan desactualizadas |
| Borrador de la nota en `AppState` | Permite avisar de cambios sin guardar y cancelar sin afectar la nota original |
| Los filtros viven en `AppState` | Se conservan al cambiar de pestaña |
| Encabezado dentro del `ListView` en Etiquetas y Buscar | Todo hace scroll junto, sin overflow aunque haya muchas etiquetas |
| `NoteCard` y `TagChip` configurables | Se reutilizan en varias pantallas |

## Datos de prueba

Se cargan desde `data/datos_prueba.dart` al iniciar la app.

| Requisito | Cumplimiento |
|---|---|
| 3 proyectos | 3 |
| 15 notas, mínimo 4 por proyecto | 15 (6, 5 y 4) |
| 8 etiquetas | 8 |
| 3 etiquetas usadas en proyectos diferentes | `Metodología` y `Bibliografía` (3 proyectos), `Entrevistas` y `Sistemas` (2) |
| 5 notas con más de 600 caracteres | 7 |
| 1 nota sin etiquetas | "Notas de la reunión con el tutor" |
| 1 etiqueta sin notas | `SinAsignar` |

## Cómo probar las funciones principales

1. **Autocompletado:** abre una nota, toca Editar y escribe `pedag` en etiquetas. Debe sugerir `Pedagogía` y ofrecer crear `pedag`.
2. **Sin duplicados:** escribe `metodologia` (sin tilde). No debe ofrecer crearla, porque ya existe.
3. **Coma y Enter:** escribe `nueva,` y debe crear y asignar `nueva`.
4. **Cambios sin guardar:** cambia el título y toca atrás. Debe pedir confirmación.
5. **Renombrar:** en Etiquetas, renombra `Sistemas` a `Arquitectura` y revisa una nota que la tenga.
6. **Duplicado al renombrar:** renombra una etiqueta a otra que ya existe. Debe rechazarlo con un mensaje.
7. **Agrupar:** en Etiquetas, selecciona `Metodología` y `Entrevistas`. Con "Todas" salen solo las notas que tienen ambas; con "Al menos una", más.
8. **Eliminar etiqueta:** el aviso indica cuántas notas se afectan, y las notas se conservan.
9. **Eliminar proyecto:** el aviso indica cuántas notas se borran, y las etiquetas se conservan.
10. **Estado de las pestañas:** escribe en Buscar, cambia de pestaña y vuelve. El texto y los filtros siguen ahí.

## Documentación adicional

- `DOCUMENTACION_ReNotes.docx`: documentación técnica completa (estructura, cada archivo, flujos, cumplimiento de requisitos y preguntas frecuentes).
- `AppState_Metodos_ReNotes.docx`: explicación de cada método de `AppState`.

## Alcance

- Los datos viven solo en memoria: al cerrar la app se pierden.
- El diseño de dos columnas para tablet que menciona `DESIGN.md` no está implementado, porque el documento de requisitos no lo pide.
