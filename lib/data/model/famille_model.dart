import 'dart:convert';

List<Famille> familleListFromJson(String str) =>
    List<Famille>.from(json.decode(str).map((x) => Famille.fromJson(x)));

String FamilleResponseToJson(FamillesResponse data) => json.encode(data.toJson());

class FamillesResponse {
  FamillesResponse({
    this.data,
  });

  List<Famille>? data;

  factory FamillesResponse.fromJson(Map<String, dynamic> json) => FamillesResponse(
    data: List<Famille>.from(json["data"].map((x) => Famille.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


class Famille {
  final String id;
  final String code;
  final String libelle;
  final String description;
  final String rayonId;
  final Rayon rayon;

  Famille({
    required this.id,
    required this.code,
    required this.libelle,
    required this.description,
    required this.rayonId,
    required this.rayon,
  });

  factory Famille.fromJson(Map<String, dynamic> json) {
    return Famille(
      id: json['id'] as String,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      rayonId: json['rayonId'] as String,
      rayon: Rayon.fromJson(json['rayon'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'libelle': libelle,
      'description': description,
      'rayonId': rayonId,
      'rayon': rayon.toJson(),
    };
  }
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
