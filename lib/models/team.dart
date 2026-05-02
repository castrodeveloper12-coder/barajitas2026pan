class Team {
  final String code;
  final String name;
  final String groupCode;
  final String flag;

  const Team({
    required this.code,
    required this.name,
    required this.groupCode,
    required this.flag,
  });
}

class GroupInfo {
  final String code;
  final List<Team> teams;
  const GroupInfo({required this.code, required this.teams});
  String get title => 'Grupo $code';
}
