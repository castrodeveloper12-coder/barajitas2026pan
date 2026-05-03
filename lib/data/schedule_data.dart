import '../models/tournament.dart';
import 'seed_data.dart';

class _Venue {
  final String stadium;
  final String city;
  const _Venue(this.stadium, this.city);
}

const Map<String, _Venue> _venues = {
  'AZT': _Venue('Estadio Azteca', 'Ciudad de México'),
  'GDL': _Venue('Estadio Akron', 'Guadalajara'),
  'MTY': _Venue('Estadio BBVA', 'Monterrey'),
  'TOR': _Venue('BMO Field', 'Toronto'),
  'VAN': _Venue('BC Place', 'Vancouver'),
  'ATL': _Venue('Mercedes-Benz Stadium', 'Atlanta'),
  'BOS': _Venue('Gillette Stadium', 'Boston'),
  'DAL': _Venue('AT&T Stadium', 'Dallas'),
  'HOU': _Venue('NRG Stadium', 'Houston'),
  'KAN': _Venue('Arrowhead Stadium', 'Kansas City'),
  'LAX': _Venue('SoFi Stadium', 'Los Ángeles'),
  'MIA': _Venue('Hard Rock Stadium', 'Miami'),
  'NYC': _Venue('MetLife Stadium', 'Nueva York / NJ'),
  'PHI': _Venue('Lincoln Financial Field', 'Filadelfia'),
  'SFO': _Venue("Levi's Stadium", 'San Francisco Bay'),
  'SEA': _Venue('Lumen Field', 'Seattle'),
};

const Map<String, List<String>> _groupVenues = {
  'A': ['AZT', 'GDL', 'MTY'],
  'B': ['TOR', 'VAN'],
  'C': ['BOS', 'NYC', 'PHI'],
  'D': ['LAX', 'SFO', 'SEA'],
  'E': ['ATL', 'MIA'],
  'F': ['HOU', 'DAL'],
  'G': ['KAN', 'ATL'],
  'H': ['BOS', 'PHI'],
  'I': ['SEA', 'SFO'],
  'J': ['MIA', 'HOU'],
  'K': ['DAL', 'KAN'],
  'L': ['NYC', 'LAX'],
};

const Map<String, List<int>> _groupMatchDays = {
  'A': [11, 18, 24],
  'B': [12, 18, 24],
  'C': [13, 19, 25],
  'D': [12, 18, 25],
  'E': [13, 19, 25],
  'F': [14, 20, 26],
  'G': [14, 20, 26],
  'H': [15, 21, 26],
  'I': [15, 21, 27],
  'J': [16, 22, 27],
  'K': [16, 22, 27],
  'L': [17, 23, 27],
};

class _R32Slot {
  final String home;
  final String away;
  final DateTime date;
  final String venue;
  const _R32Slot(this.home, this.away, this.date, this.venue);
}

final List<_R32Slot> _r32Schedule = [
  _R32Slot('1A', '3C/D/E', DateTime(2026, 6, 28), 'AZT'),
  _R32Slot('2B', '2F', DateTime(2026, 6, 28), 'TOR'),
  _R32Slot('1C', '3A/B/F', DateTime(2026, 6, 28), 'NYC'),
  _R32Slot('2D', '2E', DateTime(2026, 6, 29), 'SEA'),
  _R32Slot('1E', '3A/B/C/D', DateTime(2026, 6, 29), 'ATL'),
  _R32Slot('1F', '2C', DateTime(2026, 6, 29), 'DAL'),
  _R32Slot('1G', '3H/I/J', DateTime(2026, 6, 30), 'PHI'),
  _R32Slot('2H', '2J', DateTime(2026, 6, 30), 'KAN'),
  _R32Slot('1I', '3G/H/K', DateTime(2026, 6, 30), 'LAX'),
  _R32Slot('2K', '2L', DateTime(2026, 7, 1), 'HOU'),
  _R32Slot('1K', '3G/H/I', DateTime(2026, 7, 1), 'MIA'),
  _R32Slot('1L', '3E/F/G/H', DateTime(2026, 7, 2), 'BOS'),
  _R32Slot('1B', '3E/F/G/I', DateTime(2026, 7, 2), 'VAN'),
  _R32Slot('2A', '2I', DateTime(2026, 7, 2), 'SFO'),
  _R32Slot('1D', '3B/E/F/I/J', DateTime(2026, 7, 3), 'GDL'),
  _R32Slot('1H', '2G', DateTime(2026, 7, 3), 'MTY'),
];

class _Slot {
  final DateTime date;
  final String venue;
  const _Slot(this.date, this.venue);
}

final List<_Slot> _r16Schedule = [
  _Slot(DateTime(2026, 7, 4), 'NYC'),
  _Slot(DateTime(2026, 7, 4), 'BOS'),
  _Slot(DateTime(2026, 7, 5), 'PHI'),
  _Slot(DateTime(2026, 7, 5), 'KAN'),
  _Slot(DateTime(2026, 7, 6), 'LAX'),
  _Slot(DateTime(2026, 7, 6), 'MIA'),
  _Slot(DateTime(2026, 7, 7), 'DAL'),
  _Slot(DateTime(2026, 7, 7), 'ATL'),
];

final List<_Slot> _qfSchedule = [
  _Slot(DateTime(2026, 7, 9), 'NYC'),
  _Slot(DateTime(2026, 7, 9), 'LAX'),
  _Slot(DateTime(2026, 7, 10), 'BOS'),
  _Slot(DateTime(2026, 7, 11), 'DAL'),
];

final List<_Slot> _sfSchedule = [
  _Slot(DateTime(2026, 7, 14), 'ATL'),
  _Slot(DateTime(2026, 7, 15), 'DAL'),
];

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
      groupCode: groupCode,
    );
  }

  // 1) FASE DE GRUPOS — 72 partidos (6 por grupo, 3 jornadas)
  for (final group in kGroups) {
    final t1 = group.teams[0].code;
    final t2 = group.teams[1].code;
    final t3 = group.teams[2].code;
    final t4 = group.teams[3].code;

    final pairs = [
      (t1, t2), (t3, t4), // J1
      (t1, t3), (t4, t2), // J2
      (t4, t1), (t2, t3), // J3 (simultáneos)
    ];

    final mds = _groupMatchDays[group.code]!;
    final venues = _groupVenues[group.code]!;

    for (var i = 0; i < pairs.length; i++) {
      final mdIdx = i ~/ 2;
      final dayOfMonth = mds[mdIdx];
      final venueKey = venues[i % venues.length];

      matches.add(make(
        phase: MatchPhase.group,
        groupCode: group.code,
        home: pairs[i].$1,
        away: pairs[i].$2,
        date: DateTime(2026, 6, dayOfMonth),
        venueKey: venueKey,
      ));
    }
  }

  // 2) 16AVOS DE FINAL — 16 partidos (id 73..88)
  for (final r in _r32Schedule) {
    matches.add(make(
      phase: MatchPhase.roundOf32,
      home: r.home,
      away: r.away,
      date: r.date,
      venueKey: r.venue,
    ));
  }

  // 3) OCTAVOS — 8 partidos (id 89..96)
  for (var i = 0; i < 8; i++) {
    final s = _r16Schedule[i];
    matches.add(make(
      phase: MatchPhase.roundOf16,
      home: 'W${73 + i * 2}',
      away: 'W${74 + i * 2}',
      date: s.date,
      venueKey: s.venue,
    ));
  }

  // 4) CUARTOS — 4 partidos (id 97..100)
  for (var i = 0; i < 4; i++) {
    final s = _qfSchedule[i];
    matches.add(make(
      phase: MatchPhase.quarterFinal,
      home: 'W${89 + i * 2}',
      away: 'W${90 + i * 2}',
      date: s.date,
      venueKey: s.venue,
    ));
  }

  // 5) SEMIS — 2 partidos (id 101..102)
  for (var i = 0; i < 2; i++) {
    final s = _sfSchedule[i];
    matches.add(make(
      phase: MatchPhase.semiFinal,
      home: 'W${97 + i * 2}',
      away: 'W${98 + i * 2}',
      date: s.date,
      venueKey: s.venue,
    ));
  }

  // 6) TERCER LUGAR (id 103)
  matches.add(make(
    phase: MatchPhase.thirdPlace,
    home: 'L101',
    away: 'L102',
    date: DateTime(2026, 7, 18),
    venueKey: 'MIA',
  ));

  // 7) FINAL (id 104)
  matches.add(make(
    phase: MatchPhase.finalMatch,
    home: 'W101',
    away: 'W102',
    date: DateTime(2026, 7, 19),
    venueKey: 'NYC',
  ));

  return matches;
}
