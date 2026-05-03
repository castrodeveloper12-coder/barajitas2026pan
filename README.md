# Panini FIFA 2026 Tracker

App **gratuita y de código abierto** para llevar el control de tu álbum **Panini FIFA World Cup 2026™**. Sin login, sin anuncios, sin servidores: todo se guarda localmente en tu teléfono.

> 📂 **El código es libre.** Puedes revisarlo, copiarlo, modificarlo y compilar tu propia versión. Pull requests, forks y mejoras son bienvenidas.

---

## ✨ Funciones

- **Progreso del álbum** — porcentaje completo, repetidas, faltantes.
- **Grupos y equipos** — los 12 grupos (A–L) con sus 48 selecciones, búsqueda por país o código (BRA, ESP, A…).
- **Detalle de equipo** — los 20 stickers de cada selección (escudo, foto del equipo, 18 jugadores).
- **Especiales** — Introducción (sello + FWC 0–19) y Coca-Cola Legends (12 jugadores).
- **Repetidas / intercambio** — lista agrupada por país y botón para compartir por WhatsApp/Telegram.
- **Faltantes** con buscador.
- **🆕 Calendario oficial** — los 104 partidos del mundial con sedes, horarios y resultados editables.
  - Horarios convertidos automáticamente a **hora Colombia (UTC-5)**.
  - Tablas de posiciones que se actualizan al ingresar resultados.
  - Resolución automática de cruces (1.º, 2.º y mejores terceros).
- **Buscar barajita** por número, nombre o sección.

Todo se guarda en SQLite local; nada sale del teléfono.

---

## 📲 Cómo instalarla en Android

> Solo Android. Para iOS necesitas compilarla tú con Xcode (ver más abajo).

### 1. Descarga el APK

Descarga el archivo `.apk` desde la carpeta [`releases/`](releases/) de este repo:

| Archivo | Para | Tamaño |
|---|---|---|
| [`panini-2026-arm64.apk`](releases/panini-2026-arm64.apk) | La mayoría de teléfonos modernos (recomendado) | 7.6 MB |
| [`panini-2026-armeabi.apk`](releases/panini-2026-armeabi.apk) | Teléfonos antiguos de 32 bits | 7.2 MB |
| [`panini-2026-x86_64.apk`](releases/panini-2026-x86_64.apk) | Emuladores / tablets Intel | 7.8 MB |

Si no estás seguro, usa **`panini-2026-arm64.apk`** — funciona en casi todos los Android desde 2018.

### 2. Permite instalación desde fuentes desconocidas

En tu teléfono:

1. Abre **Ajustes → Aplicaciones** (o **Seguridad** según la marca).
2. Busca la opción **"Instalar apps desconocidas"** o **"Orígenes desconocidos"**.
3. Habilítala para tu navegador o gestor de archivos.

### 3. Instala

1. Abre el archivo `.apk` desde el gestor de archivos o descargas.
2. Toca **Instalar** y acepta los permisos.
3. Listo — busca **Panini FIFA 2026** en tu lanzador.

> Android puede mostrar un aviso "Play Protect no reconoce la app". Es normal en apps que no están en Play Store. Toca **Instalar de todas formas**.

---

## 🛠️ Compilar desde el código (opcional)

Si quieres modificar el código y generar tu propio APK:

### Requisitos

- [Flutter ≥ 3.27](https://docs.flutter.dev/get-started/install) con SDK Android instalado.
- Un equipo con `git`.

### Pasos

```bash
git clone <url-del-repo>
cd barajitas2026pan
flutter pub get
flutter run                              # para correrla en un emulador o dispositivo conectado
flutter build apk --release --split-per-abi   # para generar los APKs en build/app/outputs/flutter-apk/
```

Los APKs se generan en `build/app/outputs/flutter-apk/`.

### Estructura del proyecto

```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/        sticker.dart · team.dart · tournament.dart
├── data/          seed_data.dart · schedule_data.dart · database.dart
├── providers/     sticker_provider.dart · tournament_provider.dart
├── widgets/       progress_card.dart · sticker_tile.dart · counter_sheet.dart
└── screens/       home · groups · team_detail · specials · duplicates ·
                   missing · search · matches · match_detail · standings
```

---

## 📦 Stack

- Flutter 3.27+ / Dart 3.6+
- Material 3 con `ColorScheme.fromSeed` (verde menta `#00B894`)
- `provider` para estado reactivo
- `sqflite` para persistencia local
- `google_fonts` (Inter)
- `share_plus` para compartir la lista de repetidas

---

## 📄 Licencia y atribución

El código de esta app es **libre** — puedes usarlo, modificarlo y redistribuirlo sin restricciones.

**Nota legal:** este es un proyecto **no oficial**, hecho por aficionados. No está afiliado, patrocinado ni respaldado por **Panini Group**, **FIFA**, ni ninguna de las marcas de los patrocinadores oficiales de la Copa del Mundo. Los nombres "Panini", "FIFA World Cup 2026", logos, escudos de selecciones y demás marcas registradas pertenecen a sus respectivos dueños y se mencionan únicamente con fines descriptivos.

Si Panini, FIFA o cualquier titular de derechos quiere que se retire material, basta con abrir un *issue* en el repositorio.
