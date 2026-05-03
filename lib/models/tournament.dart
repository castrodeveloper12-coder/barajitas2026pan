enum MatchPhase {
  group,
  roundOf32,
  roundOf16,
  quarterFinal,
  semiFinal,
  thirdPlace,
  finalMatch,
}

extension MatchPhaseLabel on MatchPhase {
  String get label {
    switch (this) {
      case MatchPhase.group:
        return 'Fase de grupos';
      case MatchPhase.roundOf32:
        return '16avos de final';
      case MatchPhase.roundOf16:
        return 'Octavos de final';
      case MatchPhase.quarterFinal:
        return 'Cuartos de final';
      case MatchPhase.semiFinal:
        return 'Semifinales';
      case MatchPhase.thirdPlace:
        return 'Tercer lugar';
      case MatchPhase.finalMatch:
        return 'Final';
    }
  }

  String get shortLabel {
    switch (this) {
      case MatchPhase.group:
        return 'Grupos';
      case MatchPhase.roundOf32:
        return '16avos';
      case MatchPhase.roundOf16:
        return 'Octavos';
      case MatchPhase.quarterFinal:
        return 'Cuartos';
      case MatchPhase.semiFinal:
        return 'Semifinal';
      case MatchPhase.thirdPlace:
        return '3.er lugar';
      case MatchPhase.finalMatch:
        return 'Final';
    }
  }

  bool get isKnockout => this != MatchPhase.group;
}

class WorldCupMatch {
  final int id;
  final MatchPhase phase;
  final String? groupCode;

  String homeTeamPlaceholder;
  String awayTeamPlaceholder;

  String? resolvedHomeTeam;
  String? resolvedAwayTeam;

  int? homeScore;
  int? awayScore;

  int? homePenalties;
  int? awayPenalties;

  /// Hora del kickoff expresada como "reloj de pared" del estadio (local).
  /// Para convertir a otras zonas, sumar/restar la diferencia respecto a [utcOffsetHours].
  final DateTime date;
  final String stadium;
  final String city;

  /// Offset del estadio respecto a UTC, en horas (ej. -4 para EDT, -6 para CDMX).
  final int utcOffsetHours;

  WorldCupMatch({
    required this.id,
    required this.phase,
    required this.homeTeamPlaceholder,
    required this.awayTeamPlaceholder,
    required this.date,
    required this.stadium,
    required this.city,
    required this.utcOffsetHours,
    this.groupCode,
    this.resolvedHomeTeam,
    this.resolvedAwayTeam,
  }) {
    if (phase == MatchPhase.group) {
      resolvedHomeTeam = homeTeamPlaceholder;
      resolvedAwayTeam = awayTeamPlaceholder;
    }
  }

  bool get isPlayed => homeScore != null && awayScore != null;
  bool get hasResolvedTeams =>
      resolvedHomeTeam != null && resolvedAwayTeam != null;
  bool get isDraw => isPlayed && homeScore == awayScore;

  String? get winner {
    if (!isPlayed) return null;
    if (homeScore! > awayScore!) return resolvedHomeTeam;
    if (awayScore! > homeScore!) return resolvedAwayTeam;
    if (homePenalties != null && awayPenalties != null) {
      return homePenalties! > awayPenalties!
          ? resolvedHomeTeam
          : resolvedAwayTeam;
    }
    return null;
  }
}

class GroupStanding {
  final String teamCode;
  int played = 0;
  int won = 0;
  int drawn = 0;
  int lost = 0;
  int goalsFor = 0;
  int goalsAgainst = 0;

  GroupStanding(this.teamCode);

  int get points => (won * 3) + drawn;
  int get goalDifference => goalsFor - goalsAgainst;
}
