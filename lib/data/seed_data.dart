import '../models/sticker.dart';
import '../models/team.dart';

/// FIFA World Cup 2026 — 48 equipos, 12 grupos, según el sorteo final
/// (Kennedy Center, diciembre 2025).
const List<GroupInfo> kGroups = [
  GroupInfo(code: 'A', teams: [
    Team(code: 'MEX', name: 'México', groupCode: 'A', flag: '🇲🇽'),
    Team(code: 'RSA', name: 'Sudáfrica', groupCode: 'A', flag: '🇿🇦'),
    Team(code: 'KOR', name: 'Corea del Sur', groupCode: 'A', flag: '🇰🇷'),
    Team(code: 'CZE', name: 'Chequia', groupCode: 'A', flag: '🇨🇿'),
  ]),
  GroupInfo(code: 'B', teams: [
    Team(code: 'CAN', name: 'Canadá', groupCode: 'B', flag: '🇨🇦'),
    Team(code: 'SUI', name: 'Suiza', groupCode: 'B', flag: '🇨🇭'),
    Team(code: 'QAT', name: 'Qatar', groupCode: 'B', flag: '🇶🇦'),
    Team(code: 'BIH', name: 'Bosnia y Herzegovina', groupCode: 'B', flag: '🇧🇦'),
  ]),
  GroupInfo(code: 'C', teams: [
    Team(code: 'BRA', name: 'Brasil', groupCode: 'C', flag: '🇧🇷'),
    Team(code: 'MAR', name: 'Marruecos', groupCode: 'C', flag: '🇲🇦'),
    Team(code: 'HAI', name: 'Haití', groupCode: 'C', flag: '🇭🇹'),
    Team(code: 'SCO', name: 'Escocia', groupCode: 'C', flag: '🏴󠁧󠁢󠁳󠁣󠁴󠁿'),
  ]),
  GroupInfo(code: 'D', teams: [
    Team(code: 'USA', name: 'Estados Unidos', groupCode: 'D', flag: '🇺🇸'),
    Team(code: 'PAR', name: 'Paraguay', groupCode: 'D', flag: '🇵🇾'),
    Team(code: 'AUS', name: 'Australia', groupCode: 'D', flag: '🇦🇺'),
    Team(code: 'TUR', name: 'Turquía', groupCode: 'D', flag: '🇹🇷'),
  ]),
  GroupInfo(code: 'E', teams: [
    Team(code: 'GER', name: 'Alemania', groupCode: 'E', flag: '🇩🇪'),
    Team(code: 'CUW', name: 'Curazao', groupCode: 'E', flag: '🇨🇼'),
    Team(code: 'CIV', name: 'Costa de Marfil', groupCode: 'E', flag: '🇨🇮'),
    Team(code: 'ECU', name: 'Ecuador', groupCode: 'E', flag: '🇪🇨'),
  ]),
  GroupInfo(code: 'F', teams: [
    Team(code: 'NED', name: 'Países Bajos', groupCode: 'F', flag: '🇳🇱'),
    Team(code: 'JPN', name: 'Japón', groupCode: 'F', flag: '🇯🇵'),
    Team(code: 'TUN', name: 'Túnez', groupCode: 'F', flag: '🇹🇳'),
    Team(code: 'SWE', name: 'Suecia', groupCode: 'F', flag: '🇸🇪'),
  ]),
  GroupInfo(code: 'G', teams: [
    Team(code: 'BEL', name: 'Bélgica', groupCode: 'G', flag: '🇧🇪'),
    Team(code: 'EGY', name: 'Egipto', groupCode: 'G', flag: '🇪🇬'),
    Team(code: 'IRN', name: 'Irán', groupCode: 'G', flag: '🇮🇷'),
    Team(code: 'NZL', name: 'Nueva Zelanda', groupCode: 'G', flag: '🇳🇿'),
  ]),
  GroupInfo(code: 'H', teams: [
    Team(code: 'ESP', name: 'España', groupCode: 'H', flag: '🇪🇸'),
    Team(code: 'CPV', name: 'Cabo Verde', groupCode: 'H', flag: '🇨🇻'),
    Team(code: 'KSA', name: 'Arabia Saudita', groupCode: 'H', flag: '🇸🇦'),
    Team(code: 'URU', name: 'Uruguay', groupCode: 'H', flag: '🇺🇾'),
  ]),
  GroupInfo(code: 'I', teams: [
    Team(code: 'FRA', name: 'Francia', groupCode: 'I', flag: '🇫🇷'),
    Team(code: 'SEN', name: 'Senegal', groupCode: 'I', flag: '🇸🇳'),
    Team(code: 'NOR', name: 'Noruega', groupCode: 'I', flag: '🇳🇴'),
    Team(code: 'IRQ', name: 'Irak', groupCode: 'I', flag: '🇮🇶'),
  ]),
  GroupInfo(code: 'J', teams: [
    Team(code: 'ARG', name: 'Argentina', groupCode: 'J', flag: '🇦🇷'),
    Team(code: 'ALG', name: 'Argelia', groupCode: 'J', flag: '🇩🇿'),
    Team(code: 'AUT', name: 'Austria', groupCode: 'J', flag: '🇦🇹'),
    Team(code: 'JOR', name: 'Jordania', groupCode: 'J', flag: '🇯🇴'),
  ]),
  GroupInfo(code: 'K', teams: [
    Team(code: 'POR', name: 'Portugal', groupCode: 'K', flag: '🇵🇹'),
    Team(code: 'UZB', name: 'Uzbekistán', groupCode: 'K', flag: '🇺🇿'),
    Team(code: 'COL', name: 'Colombia', groupCode: 'K', flag: '🇨🇴'),
    Team(code: 'COD', name: 'RD del Congo', groupCode: 'K', flag: '🇨🇩'),
  ]),
  GroupInfo(code: 'L', teams: [
    Team(code: 'ENG', name: 'Inglaterra', groupCode: 'L', flag: '🏴󠁧󠁢󠁥󠁮󠁧󠁿'),
    Team(code: 'CRO', name: 'Croacia', groupCode: 'L', flag: '🇭🇷'),
    Team(code: 'GHA', name: 'Ghana', groupCode: 'L', flag: '🇬🇭'),
    Team(code: 'PAN', name: 'Panamá', groupCode: 'L', flag: '🇵🇦'),
  ]),
];

/// 00 + FWC 1–19: Introducción + Historia de campeones
/// Checklist oficial verificado de Panini FIFA World Cup 2026.
const List<String> kIntroTitles = [
  'Sello Panini',                              // 00
  'Emblema oficial (1/2)',                      // FWC 1
  'Emblema oficial (2/2)',                      // FWC 2
  'Mascotas oficiales (Maple · Zayu · Clutch)', // FWC 3
  'Eslogan oficial',                            // FWC 4
  'Balón oficial',                              // FWC 5
  'Emblema sede · CAN (Canadá)',                // FWC 6
  'Emblema sede · MEX (México)',                 // FWC 7
  'Emblema sede · USA (Estados Unidos)',         // FWC 8
  'Italia 1934',                                // FWC 9
  'Uruguay 1950',                               // FWC 10
  'Alemania 1954',                              // FWC 11
  'Brasil 1962',                                // FWC 12
  'Alemania 1974',                              // FWC 13
  'Argentina 1986',                             // FWC 14
  'Brasil 1994',                                // FWC 15
  'Brasil 2002',                                // FWC 16
  'Italia 2006',                                // FWC 17
  'Alemania 2014',                              // FWC 18
  'Argentina 2022',                             // FWC 19
];

const List<String> kCocaColaLegends = [
  'Lamine Yamal',
  'Lautaro Martínez',
  'Harry Kane',
  'Joshua Kimmich',
  'Vinícius Jr.',
  'Kylian Mbappé',
  'Jude Bellingham',
  'Erling Haaland',
  'Pedri',
  'Federico Valverde',
  'Achraf Hakimi',
  'Cristiano Ronaldo',
];

List<Sticker> buildAllStickers() {
  final list = <Sticker>[];
  var globalNumber = 1;

  // Sección Introducción
  for (var i = 0; i < kIntroTitles.length; i++) {
    final isZero = i == 0;
    list.add(Sticker(
      id: isZero ? 'INT_00' : 'INT_$i',
      label: isZero ? '00' : 'FWC $i',
      name: kIntroTitles[i],
      section: 'Introducción',
      kind: StickerKind.intro,
      orderInTeam: globalNumber++,
    ));
  }

  // Equipos por grupo
  for (final group in kGroups) {
    for (final team in group.teams) {
      // 1: Escudo
      list.add(Sticker(
        id: '${team.code}_CREST',
        label: '${team.code} 1',
        name: 'Escudo de ${team.name}',
        section: team.name,
        groupCode: group.code,
        teamCode: team.code,
        kind: StickerKind.crest,
        orderInTeam: 1,
      ));

      // 2..20: Jugadores y Foto de Equipo en la posición 13
      int playerCounter = 1;
      for (var n = 2; n <= 20; n++) {
        if (n == 13) {
          // 13: Foto del equipo
          list.add(Sticker(
            id: '${team.code}_PHOTO',
            label: '${team.code} 13',
            name: 'Foto oficial del equipo',
            section: team.name,
            groupCode: group.code,
            teamCode: team.code,
            kind: StickerKind.teamPhoto,
            orderInTeam: 13,
          ));
        } else {
          // Jugador
          list.add(Sticker(
            id: '${team.code}_P$playerCounter',
            label: '${team.code} $n',
            name: 'Jugador #$playerCounter',
            section: team.name,
            groupCode: group.code,
            teamCode: team.code,
            kind: StickerKind.player,
            orderInTeam: n,
          ));
          playerCounter++;
        }
      }
    }
  }

  // Coca-Cola Legends
  for (var i = 0; i < kCocaColaLegends.length; i++) {
    list.add(Sticker(
      id: 'CCL${i + 1}',
      label: 'CCL${i + 1}',
      name: kCocaColaLegends[i],
      section: 'Coca-Cola Legends',
      kind: StickerKind.cocaCola,
      orderInTeam: i + 1,
    ));
  }

  return list;
}
