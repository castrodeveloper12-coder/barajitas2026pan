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

const List<String> kIntroTitles = [
  'Logo FIFA World Cup 2026',
  'Trofeo de la Copa del Mundo',
  'Balón Oficial',
  'Mascotas Maple, Zayu y Clutch',
  'Estadios anfitriones (collage)',
  'Canadá - País anfitrión',
  'México - País anfitrión',
  'Estados Unidos - País anfitrión',
  'Cuadro del torneo',
];

const List<String> kMuseumTitles = [
  'Uruguay 1930',
  'Italia 1934 / 1938',
  'Alemania 1954 / 1974 / 1990 / 2014',
  'Brasil 1958 / 1962 / 1970 / 1994 / 2002',
  'Inglaterra 1966',
  'Argentina 1978 / 1986 / 2022',
  'Francia 1998 / 2018',
  'España 2010',
  'Trofeo histórico',
  'Mejores momentos',
  'Estrellas legendarias',
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
    list.add(Sticker(
      id: 'INT${i + 1}',
      label: 'FWC${i + 1}',
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
      // 2: Foto del equipo
      list.add(Sticker(
        id: '${team.code}_PHOTO',
        label: '${team.code} 2',
        name: 'Foto oficial del equipo',
        section: team.name,
        groupCode: group.code,
        teamCode: team.code,
        kind: StickerKind.teamPhoto,
        orderInTeam: 2,
      ));
      // 3..20: Jugadores
      for (var p = 1; p <= 18; p++) {
        list.add(Sticker(
          id: '${team.code}_P$p',
          label: '${team.code} ${p + 2}',
          name: 'Jugador #$p',
          section: team.name,
          groupCode: group.code,
          teamCode: team.code,
          kind: StickerKind.player,
          orderInTeam: p + 2,
        ));
      }
    }
  }

  // FIFA Museum
  for (var i = 0; i < kMuseumTitles.length; i++) {
    list.add(Sticker(
      id: 'MUS${i + 1}',
      label: 'MUS${i + 1}',
      name: kMuseumTitles[i],
      section: 'FIFA Museum',
      kind: StickerKind.museum,
      orderInTeam: i + 1,
    ));
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
