import 'dart:convert';

List<Secteur> secteurListFromJson(String str) =>
    List<Secteur>.from(json.decode(str).map((x) => Secteur.fromJson(x)));

String SecteurResponseToJson(SecteurResponse data) => json.encode(data.toJson());

class SecteurResponse {
  SecteurResponse({
    this.data,
  });

  List<Secteur>? data;

  factory SecteurResponse.fromJson(List<dynamic> json) => SecteurResponse(
    data: List<Secteur>.from(json.map((x) => Secteur.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Secteur {
  final String id;
  final String code;
  final String libelle;
  final String description;

  Secteur({
    required this.id,
    required this.code,
    required this.libelle,
    required this.description,
  });

  factory Secteur.fromJson(Map<String, dynamic> json) {
    return Secteur(
      id: json['id'] as String,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'libelle': libelle,
      'description': description,
    };
  }
}
