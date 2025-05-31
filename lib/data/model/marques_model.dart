import 'dart:convert';

List<Marque> marqueListFromJson(String str) =>
    List<Marque>.from(json.decode(str).map((x) => Marque.fromJson(x)));

String MarqueResponseToJson(MarquesResponse data) => json.encode(data.toJson());

class MarquesResponse {
  MarquesResponse({
    this.data,
  });

  List<Marque>? data;

  factory MarquesResponse.fromJson(Map<String, dynamic> json) => MarquesResponse(
    data: List<Marque>.from(json["data"].map((x) => Marque.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
class Marque {
  final String id;
  final String code;
  final String nom;
  final String description;
  final bool statut;

  Marque({
    required this.id,
    required this.code,
    required this.nom,
    required this.description,
    required this.statut,
  });

  factory Marque.fromJson(Map<String, dynamic> json) {
    return Marque(
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
