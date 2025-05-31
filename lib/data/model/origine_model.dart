import 'dart:convert';

List<Origine> origineListFromJson(String str) =>
    List<Origine>.from(json.decode(str).map((x) => Origine.fromJson(x)));
String OrigineResponseToJson(OriginesResponse data) => json.encode(data.toJson());

class OriginesResponse {
  OriginesResponse({
    this.data,
  });

  List<Origine>? data;

  factory OriginesResponse.fromJson(Map<String, dynamic> json) => OriginesResponse(
    data: List<Origine>.from(json["data"].map((x) => Origine.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Origine {
  final String id;
  final String code;
  final String nom;
  final String description;
  final bool statut;

  Origine({
    required this.id,
    required this.code,
    required this.nom,
    required this.description,
    required this.statut,
  });

  factory Origine.fromJson(Map<String, dynamic> json) {
    return Origine(
      id: json['id'] as String,
      code: json['code'] as String,
      nom: json['nom'] as String,
      description: json['description'] as String,
      statut: json['statut'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'description': description,
      'statut': statut,
    };
  }
}
