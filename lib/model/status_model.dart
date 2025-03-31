class Stat {
  final int id;
  final int isGroup;
  final int? groupSequence; // Nullable because some fields don't have a value
  final int groupId;
  final int sequence;
  final String name;
  final String? abbreviation; // Nullable since some abbreviations are empty
  final int isVisible;

  Stat({
    required this.id,
    required this.isGroup,
    this.groupSequence,
    required this.groupId,
    required this.sequence,
    required this.name,
    this.abbreviation,
    required this.isVisible,
  });

  factory Stat.fromMap(Map<String, dynamic> map) {
    return Stat(
      id: int.parse(map['id']),
      isGroup: int.parse(map['isgrp']),
      groupSequence: map['grpseq'] != null ? int.tryParse(map['grpseq']) : null,
      groupId: int.parse(map['grpid']),
      sequence: int.parse(map['seq']),
      name: map['nm'],
      abbreviation: map['abr'].isNotEmpty ? map['abr'] : null,
      isVisible: int.parse(map['isvis']),
    );
  }
}

class Data {
  final List<Stat> statList;

  Data({required this.statList});

  factory Data.fromMap(Map<String, dynamic> map) {
    var statItems =
        (map['stat'] as List).map((item) => Stat.fromMap(item)).toList();
    return Data(statList: statItems);
  }
}
