enum StickerKind { crest, teamPhoto, player, intro, museum, cocaCola }

class Sticker {
  final String id;
  final String label;
  final String name;
  final String section;
  final String? groupCode;
  final String? teamCode;
  final StickerKind kind;
  final int orderInTeam;
  int owned;
  String? customName;

  Sticker({
    required this.id,
    required this.label,
    required this.name,
    required this.section,
    required this.kind,
    required this.orderInTeam,
    this.groupCode,
    this.teamCode,
    this.owned = 0,
    this.customName,
  });

  bool get isOwned => owned > 0;
  int get duplicates => owned > 1 ? owned - 1 : 0;
  String get displayName =>
      (customName != null && customName!.trim().isNotEmpty)
          ? customName!.trim()
          : name;

  Map<String, Object?> toMap() => {
        'id': id,
        'label': label,
        'name': name,
        'section': section,
        'group_code': groupCode,
        'team_code': teamCode,
        'kind': kind.name,
        'order_in_team': orderInTeam,
        'owned': owned,
        'custom_name': customName,
      };

  static Sticker fromMap(Map<String, Object?> m) => Sticker(
        id: m['id'] as String,
        label: m['label'] as String,
        name: m['name'] as String,
        section: m['section'] as String,
        groupCode: m['group_code'] as String?,
        teamCode: m['team_code'] as String?,
        kind: StickerKind.values.firstWhere((k) => k.name == m['kind']),
        orderInTeam: (m['order_in_team'] as int?) ?? 0,
        owned: (m['owned'] as int?) ?? 0,
        customName: m['custom_name'] as String?,
      );
}
