import 'dart:convert';

List<SousFamille> sousFamilleListFromJson(String str) =>
    List<SousFamille>.from(json.decode(str).map((x) => SousFamille.fromJson(x)));

String SousFamilleResponseToJson(SousFamillesResponse data) => json.encode(data.toJson());

class SousFamillesResponse {
  SousFamillesResponse({
    this.data,
  });

  List<SousFamille>? data;

  factory SousFamillesResponse.fromJson(Map<String, dynamic> json) => SousFamillesResponse(
    data: List<SousFamille>.from(json["data"].map((x) => SousFamille.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class SousFamille {
  final String id;
  final String code;
  final String libelle;
  final String description;
  final String familleId;
  final Famille famille;

  SousFamille({
    required this.id,
    required this.code,
    required this.libelle,
    required this.description,
    required this.familleId,
    required this.famille,
  });

  factory SousFamille.fromJson(Map<String, dynamic> json) {
    return SousFamille(
      id: json['id'] as String,
      code: json['code'] as String,
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      familleId: json['familleId'] as String,
      famille: Famille.fromJson(json['famille'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'libelle': libelle,
      'description': description,
      'familleId': familleId,
      'famille': famille.toJson(),
    };
  }
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
