import 'dart:convert';

List<Rayon> rayonListFromJson(String str) =>
    List<Rayon>.from(json.decode(str).map((x) => Rayon.fromJson(x)));


String RayonResponseToJson(RayonsResponse data) => json.encode(data.toJson());

class RayonsResponse {
  RayonsResponse({
    this.data,
  });

  List<Rayon>? data;

  factory RayonsResponse.fromJson(Map<String, dynamic> json) => RayonsResponse(
    data: List<Rayon>.from(json["data"].map((x) => Rayon.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Rayon {
  final String id;
  final String code;
  final String libelle;
  final String description;
  final String secteurId;
  final Secteur secteur;

  Rayon({
    required this.id,
    required this.code,
    required this.libelle,
    required this.description,
    required this.secteurId,
    required this.secteur,
  });

  factory Rayon.fromJson(Map<String, dynamic> json) {
    return Rayon(
      id: json['id'] as String,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      secteurId: json['secteurId'] as String,
      secteur: Secteur.fromJson(json['secteur'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'libelle': libelle,
      'description': description,
      'secteurId': secteurId,
      'secteur': secteur.toJson(),
    };
  }
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
