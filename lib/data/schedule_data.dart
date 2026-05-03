import '../models/tournament.dart';
import 'seed_data.dart';

class _Venue {
  final String stadium;
  final String city;
  // Offset respecto a UTC en junio-julio 2026 (con DST aplicado donde corresponde).
  // México (CDMX, GDL, MTY) no observa DST desde 2022 → -6 fijo.
  // EE.UU./Canadá: en verano están en horario de verano (EDT=-4, CDT=-5, PDT=-7).
  final int utcOffsetHours;
  const _Venue(this.stadium, this.city, this.utcOffsetHours);
}

const Map<String, _Venue> _venues = {
  'AZT': _Venue('Estadio Azteca', 'Ciudad de México', -6),
  'GDL': _Venue('Estadio Akron', 'Guadalajara', -6),
  'MTY': _Venue('Estadio BBVA', 'Monterrey', -6),
  'TOR': _Venue('BMO Field', 'Toronto', -4),
  'VAN': _Venue('BC Place', 'Vancouver', -7),
  'ATL': _Venue('Mercedes-Benz Stadium', 'Atlanta', -4),
  'BOS': _Venue('Gillette Stadium', 'Boston', -4),
  'DAL': _Venue('AT&T Stadium', 'Dallas', -5),
  'HOU': _Venue('NRG Stadium', 'Houston', -5),
  'KAN': _Venue('Arrowhead Stadium', 'Kansas City', -5),
  'LAX': _Venue('SoFi Stadium', 'Los Ángeles', -7),
  'MIA': _Venue('Hard Rock Stadium', 'Miami', -4),
  'NYC': _Venue('MetLife Stadium', 'Nueva York / NJ', -4),
  'PHI': _Venue('Lincoln Financial Field', 'Filadelfia', -4),
  'SFO': _Venue("Levi's Stadium", 'San Francisco Bay', -7),
  'SEA': _Venue('Lumen Field', 'Seattle', -7),
};

/// Partido de fase de grupos. Hora almacenada en HORA LOCAL DEL ESTADIO
/// (la conversión a hora Colombia se hace en la UI usando el offset de la sede).
class _GM {
  final String group;
  final int home; // 1..4 dentro del grupo
  final int away;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final String venue;
  const _GM(this.group, this.home, this.away, this.month, this.day, this.hour,
      this.minute, this.venue);
}

const List<_GM> _groupSchedule = [
  // ── Grupo A — México (1) · Sudáfrica (2) · Corea Sur (3) · Chequia (4)
  _GM('A', 1, 2, 6, 11, 13, 0, 'AZT'),
  _GM('A', 3, 4, 6, 11, 20, 0, 'GDL'),
  _GM('A', 4, 2, 6, 18, 12, 0, 'ATL'),
  _GM('A', 1, 3, 6, 18, 19, 0, 'GDL'),
  _GM('A', 4, 1, 6, 24, 19, 0, 'AZT'),
  _GM('A', 2, 3, 6, 24, 19, 0, 'MTY'),

  // ── Grupo B — Canadá (1) · Suiza (2) · Qatar (3) · BIH (4)
  _GM('B', 1, 4, 6, 12, 15, 0, 'TOR'),
  _GM('B', 3, 2, 6, 13, 12, 0, 'SFO'),
  _GM('B', 2, 4, 6, 18, 12, 0, 'LAX'),
  _GM('B', 1, 3, 6, 18, 15, 0, 'VAN'),
  _GM('B', 2, 1, 6, 24, 12, 0, 'VAN'),
  _GM('B', 4, 3, 6, 24, 12, 0, 'SEA'),

  // ── Grupo C — Brasil (1) · Marruecos (2) · Haití (3) · Escocia (4)
  _GM('C', 1, 2, 6, 13, 18, 0, 'NYC'),
  _GM('C', 3, 4, 6, 13, 21, 0, 'BOS'),
  _GM('C', 4, 2, 6, 19, 18, 0, 'BOS'),
  _GM('C', 1, 3, 6, 19, 20, 30, 'PHI'),
  _GM('C', 4, 1, 6, 24, 18, 0, 'MIA'),
  _GM('C', 2, 3, 6, 24, 18, 0, 'ATL'),

  // ── Grupo D — USA (1) · Paraguay (2) · Australia (3) · Turquía (4)
  _GM('D', 1, 2, 6, 12, 18, 0, 'LAX'),
  _GM('D', 3, 4, 6, 13, 21, 0, 'VAN'),
  _GM('D', 1, 3, 6, 19, 12, 0, 'SEA'),
  _GM('D', 4, 2, 6, 19, 20, 0, 'SFO'),
  _GM('D', 4, 1, 6, 25, 19, 0, 'LAX'),
  _GM('D', 2, 3, 6, 25, 19, 0, 'SFO'),

  // ── Grupo E — Alemania (1) · Curazao (2) · Costa de Marfil (3) · Ecuador (4)
  _GM('E', 1, 2, 6, 14, 12, 0, 'HOU'),
  _GM('E', 3, 4, 6, 14, 19, 0, 'PHI'),
  _GM('E', 1, 3, 6, 20, 16, 0, 'TOR'),
  _GM('E', 4, 2, 6, 20, 19, 0, 'KAN'),
  _GM('E', 2, 3, 6, 25, 16, 0, 'PHI'),
  _GM('E', 4, 1, 6, 25, 16, 0, 'NYC'),

  // ── Grupo F — Países Bajos (1) · Japón (2) · Túnez (3) · Suecia (4)
  _GM('F', 1, 2, 6, 14, 15, 0, 'DAL'),
  _GM('F', 4, 3, 6, 14, 20, 0, 'MTY'),
  _GM('F', 1, 4, 6, 20, 12, 0, 'HOU'),
  _GM('F', 3, 2, 6, 20, 22, 0, 'MTY'),
  _GM('F', 2, 4, 6, 25, 18, 0, 'DAL'),
  _GM('F', 3, 1, 6, 25, 18, 0, 'KAN'),

  // ── Grupo G — Bélgica (1) · Egipto (2) · Irán (3) · Nueva Zelanda (4)
  _GM('G', 1, 2, 6, 15, 12, 0, 'SEA'),
  _GM('G', 3, 4, 6, 15, 18, 0, 'LAX'),
  _GM('G', 1, 3, 6, 21, 12, 0, 'LAX'),
  _GM('G', 4, 2, 6, 21, 18, 0, 'VAN'),
  _GM('G', 2, 3, 6, 26, 20, 0, 'SEA'),
  _GM('G', 4, 1, 6, 26, 20, 0, 'VAN'),

  // ── Grupo H — España (1) · Cabo Verde (2) · Arabia Saudita (3) · Uruguay (4)
  _GM('H', 1, 2, 6, 15, 12, 0, 'ATL'),
  _GM('H', 3, 4, 6, 15, 18, 0, 'MIA'),
  _GM('H', 1, 3, 6, 21, 12, 0, 'ATL'),
  _GM('H', 4, 2, 6, 21, 18, 0, 'MIA'),
  _GM('H', 2, 3, 6, 26, 19, 0, 'HOU'),
  _GM('H', 4, 1, 6, 26, 18, 0, 'GDL'),

  // ── Grupo I — Francia (1) · Senegal (2) · Noruega (3) · Irak (4)
  _GM('I', 1, 2, 6, 16, 15, 0, 'NYC'),
  _GM('I', 4, 3, 6, 16, 18, 0, 'BOS'),
  _GM('I', 1, 4, 6, 22, 17, 0, 'PHI'),
  _GM('I', 3, 2, 6, 22, 20, 0, 'NYC'),
  _GM('I', 3, 1, 6, 26, 15, 0, 'BOS'),
  _GM('I', 2, 4, 6, 26, 15, 0, 'TOR'),

  // ── Grupo J — Argentina (1) · Argelia (2) · Austria (3) · Jordania (4)
  _GM('J', 1, 2, 6, 16, 19, 0, 'KAN'),
  _GM('J', 3, 4, 6, 16, 21, 0, 'SFO'),
  _GM('J', 1, 3, 6, 22, 11, 0, 'DAL'),
  _GM('J', 4, 2, 6, 22, 20, 0, 'SFO'),
  _GM('J', 2, 3, 6, 27, 20, 0, 'KAN'),
  _GM('J', 4, 1, 6, 27, 20, 0, 'DAL'),

  // ── Grupo K — Portugal (1) · Uzbekistán (2) · Colombia (3) · RD Congo (4)
  _GM('K', 1, 4, 6, 17, 12, 0, 'HOU'),
  _GM('K', 2, 3, 6, 17, 20, 0, 'AZT'),
  _GM('K', 1, 2, 6, 23, 12, 0, 'HOU'),
  _GM('K', 3, 4, 6, 23, 20, 0, 'GDL'),
  _GM('K', 3, 1, 6, 27, 19, 30, 'MIA'),
  _GM('K', 4, 2, 6, 27, 19, 30, 'ATL'),

  // ── Grupo L — Inglaterra (1) · Croacia (2) · Ghana (3) · Panamá (4)
  _GM('L', 1, 2, 6, 17, 15, 0, 'DAL'),
  _GM('L', 3, 4, 6, 17, 19, 0, 'TOR'),
  _GM('L', 1, 3, 6, 23, 16, 0, 'BOS'),
  _GM('L', 4, 2, 6, 23, 19, 0, 'TOR'),
  _GM('L', 4, 1, 6, 27, 17, 0, 'NYC'),
  _GM('L', 2, 3, 6, 27, 17, 0, 'PHI'),
];

/// Eliminatoria. Hora local del estadio.
class _KO {
  final String home; // placeholder ('1A', '2B', '3A/B/C/D/F', 'W73', 'L101'…)
  final String away;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final String venue;
  const _KO(this.home, this.away, this.month, this.day, this.hour, this.minute,
      this.venue);
}

/// 16avos de final (IDs 73-88) — orden idéntico al fixture oficial FIFA.
const List<_KO> _r32Schedule = [
  _KO('2A', '2B',                6, 28, 10,  0, 'LAX'), // 73
  _KO('1E', '3A/B/C/D/F',        6, 29, 16, 30, 'BOS'), // 74
  _KO('1F', '2C',                6, 29, 18,  0, 'MTY'), // 75
  _KO('1C', '2F',                6, 29, 14,  0, 'HOU'), // 76
  _KO('1I', '3C/D/F/G/H',        6, 30, 17,  0, 'NYC'), // 77
  _KO('2E', '2I',                6, 30, 11,  0, 'DAL'), // 78
  _KO('1A', '3C/E/F/H/I',        6, 30, 18,  0, 'AZT'), // 79
  _KO('1L', '3E/H/I/J/K',        7,  1, 12,  0, 'ATL'), // 80
  _KO('1D', '3B/E/F/I/J',        7,  1, 14,  0, 'SFO'), // 81
  _KO('1G', '3A/E/H/I/J',        7,  1, 11,  0, 'SEA'), // 82
  _KO('2K', '2L',                7,  2, 19,  0, 'TOR'), // 83
  _KO('1H', '2J',                7,  2,  9,  0, 'LAX'), // 84
  _KO('1B', '3E/F/G/I/J',        7,  2, 17,  0, 'VAN'), // 85
  _KO('1J', '2H',                7,  3, 18,  0, 'MIA'), // 86
  _KO('1K', '3D/E/I/J/L',        7,  3, 19, 30, 'KAN'), // 87
  _KO('2D', '2G',                7,  3, 12,  0, 'DAL'), // 88
];

/// Octavos (IDs 89-96)
const List<_KO> _r16Schedule = [
  _KO('W74', 'W77', 7, 4, 17,  0, 'PHI'), // 89
  _KO('W73', 'W75', 7, 4, 11,  0, 'HOU'), // 90
  _KO('W76', 'W78', 7, 5, 16,  0, 'NYC'), // 91
  _KO('W79', 'W80', 7, 5, 17,  0, 'AZT'), // 92
  _KO('W83', 'W84', 7, 6, 13,  0, 'DAL'), // 93
  _KO('W81', 'W82', 7, 6, 14,  0, 'SEA'), // 94
  _KO('W86', 'W88', 7, 7, 12,  0, 'ATL'), // 95
  _KO('W85', 'W87', 7, 7, 10,  0, 'VAN'), // 96
];

/// Cuartos (IDs 97-100)
const List<_KO> _qfSchedule = [
  _KO('W89', 'W90', 7,  9, 16, 0, 'BOS'), // 97
  _KO('W93', 'W94', 7, 10,  9, 0, 'LAX'), // 98
  _KO('W91', 'W92', 7, 11, 17, 0, 'MIA'), // 99
  _KO('W95', 'W96', 7, 11, 19, 0, 'KAN'), // 100
];

/// Semis (IDs 101-102)
const List<_KO> _sfSchedule = [
  _KO('W97', 'W98',  7, 14, 13, 0, 'DAL'), // 101
  _KO('W99', 'W100', 7, 15, 15, 0, 'ATL'), // 102
];

/// 3.er lugar (ID 103) y Final (ID 104)
const _KO _thirdPlace = _KO('L101', 'L102', 7, 18, 17, 0, 'MIA');
const _KO _finalMatch = _KO('W101', 'W102', 7, 19, 15, 0, 'NYC');

List<WorldCupMatch> buildTournamentSchedule() {
  final matches = <WorldCupMatch>[];
  int matchId = 1;

  WorldCupMatch make({
    required MatchPhase phase,
    required String home,
    required String away,
    required DateTime date,
    required String venueKey,
    String? groupCode,
  }) {
    final v = _venues[venueKey]!;
    return WorldCupMatch(
      id: matchId++,
      phase: phase,
      homeTeamPlaceholder: home,
      awayTeamPlaceholder: away,
      date: date,
      stadium: v.stadium,
      city: v.city,
      utcOffsetHours: v.utcOffsetHours,
      groupCode: groupCode,
    );
  }

  // 1) FASE DE GRUPOS — 72 partidos
  for (final gm in _groupSchedule) {
    final group = kGroups.firstWhere((g) => g.code == gm.group);
    final home = group.teams[gm.home - 1].code;
    final away = group.teams[gm.away - 1].code;
    matches.add(make(
      phase: MatchPhase.group,
      groupCode: gm.group,
      home: home,
      away: away,
      date: DateTime(2026, gm.month, gm.day, gm.hour, gm.minute),
      venueKey: gm.venue,
    ));
  }

  // 2) 16AVOS (73-88)
  for (final r in _r32Schedule) {
    matches.add(make(
      phase: MatchPhase.roundOf32,
      home: r.home,
      away: r.away,
      date: DateTime(2026, r.month, r.day, r.hour, r.minute),
      venueKey: r.venue,
    ));
  }

  // 3) OCTAVOS (89-96)
  for (final r in _r16Schedule) {
    matches.add(make(
      phase: MatchPhase.roundOf16,
      home: r.home,
      away: r.away,
      date: DateTime(2026, r.month, r.day, r.hour, r.minute),
      venueKey: r.venue,
    ));
  }

  // 4) CUARTOS (97-100)
  for (final r in _qfSchedule) {
    matches.add(make(
      phase: MatchPhase.quarterFinal,
      home: r.home,
      away: r.away,
      date: DateTime(2026, r.month, r.day, r.hour, r.minute),
      venueKey: r.venue,
    ));
  }

  // 5) SEMIS (101-102)
  for (final r in _sfSchedule) {
    matches.add(make(
      phase: MatchPhase.semiFinal,
      home: r.home,
      away: r.away,
      date: DateTime(2026, r.month, r.day, r.hour, r.minute),
      venueKey: r.venue,
    ));
  }

  // 6) 3.er LUGAR (103)
  matches.add(make(
    phase: MatchPhase.thirdPlace,
    home: _thirdPlace.home,
    away: _thirdPlace.away,
    date: DateTime(2026, _thirdPlace.month, _thirdPlace.day, _thirdPlace.hour,
        _thirdPlace.minute),
    venueKey: _thirdPlace.venue,
  ));

  // 7) FINAL (104)
  matches.add(make(
    phase: MatchPhase.finalMatch,
    home: _finalMatch.home,
    away: _finalMatch.away,
    date: DateTime(2026, _finalMatch.month, _finalMatch.day, _finalMatch.hour,
        _finalMatch.minute),
    venueKey: _finalMatch.venue,
  ));

  return matches;
}
