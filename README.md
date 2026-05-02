# Panini FIFA 2026 Tracker

App Flutter moderna para llevar el control del álbum **Panini FIFA World Cup 2026™**. Sin login, base de datos 100 % local (SQLite/sqflite), tema claro y oscuro automático, lista de **repetidas para intercambiar** y de **faltantes**.

## ¿Qué incluye el álbum?

- **48 selecciones** repartidas en **12 grupos (A–L)** según el sorteo final.
- **20 stickers por equipo** = 1 escudo + 1 foto del equipo + 18 jugadores → 960 base.
- **9 Introducción** (logo, trofeo, balón, mascotas, anfitriones, cuadro, etc.).
- **11 FIFA Museum** (campeones históricos del mundial).
- **12 Coca-Cola Legends** (sección parelela: Yamal, Mbappé, Kane, Bellingham, Haaland…).

Total registrable en la app: **992** stickers.

## Funciones

- **Inicio** con porcentaje, faltantes y repetidas.
- **Grupos** con progreso por grupo y por equipo.
- **Detalle de equipo** con grilla de los 20 stickers — toca para sumar, mantén presionado para restar.
- **Especiales** con pestañas: Introducción, FIFA Museum, Coca-Cola Legends.
- **Repetidas / Intercambio**: lista agrupada por país con botón para compartir por WhatsApp, Telegram, etc.
- **Faltantes** con buscador.
- **Reiniciar álbum** desde el menú.

## Cómo correrla

> Este repositorio contiene únicamente el código Dart y la configuración. Antes de correr necesitas que Flutter genere las carpetas de plataforma (`android/`, `ios/`, etc.).

```bash
# 1. Instala Flutter (si no lo tienes): https://docs.flutter.dev/get-started/install
flutter --version  # 3.19+ recomendado

# 2. Genera las carpetas nativas dentro del proyecto
cd barajitas2026pan
flutter create .   # respeta el código existente y solo crea lo que falta

# 3. Instala dependencias
flutter pub get

# 4. Corre en tu dispositivo o emulador
flutter run
```

## Stack

- Flutter 3.19+ / Dart 3.3+
- Material 3 con `ColorScheme.fromSeed`
- `provider` para estado
- `sqflite` para persistencia local
- `google_fonts` (Inter)
- `share_plus` para compartir la lista de repetidas

## Estructura

```
lib/
├── main.dart
├── theme/app_theme.dart
├── models/        sticker.dart · team.dart
├── data/          seed_data.dart · database.dart
├── providers/     sticker_provider.dart
├── widgets/       progress_card.dart · sticker_tile.dart
└── screens/       home · groups · team_detail · specials · duplicates · missing
```

## Notas

Los nombres de los jugadores aún no se publican oficialmente sticker por sticker. La app deja **18 espacios numerados por equipo** (Jugador #1 … #18) que puedes editar en `lib/data/seed_data.dart` cuando Panini libere el checklist final.
