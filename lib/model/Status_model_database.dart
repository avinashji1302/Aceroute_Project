import 'package:xml/xml.dart';

class Status {
  final String id;
  final String isGroup;
  final String groupSequence;
  final String groupId;
  final String sequence;
  final String name;
  final String abbreviation;
  final String isVisible;

  Status({
    required this.id,
    required this.isGroup,
    required this.groupSequence,
    required this.groupId,
    required this.sequence,
    required this.name,
    required this.abbreviation,
    required this.isVisible,
  });

  // Convert from XML element to JSON
  factory Status.fromXmlElement(XmlElement element) {
    return Status(
      id: element.findElements('id').single.text,
      isGroup: element.findElements('isgrp').single.text,
      groupSequence: element.findElements('grpseq').single.text,
      groupId: element.findElements('grpid').single.text,
      sequence: element.findElements('seq').single.text,
      name: element.findElements('nm').single.text,
      abbreviation: element.findElements('abr').single.text,
      isVisible: element.findElements('isvis').single.text,
    );
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isGroup': isGroup,
      'groupSequence': groupSequence,
      'groupId': groupId,
      'sequence': sequence,
      'name': name,
      'abbreviation': abbreviation,
      'isVisible': isVisible,
    };
  }

  // Convert from JSON to object
  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      id: json['id'],
      isGroup: json['isGroup'],
      groupSequence: json['groupSequence'],
      groupId: json['groupId'],
      sequence: json['sequence'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      isVisible: json['isVisible'],
    );
  }
}
