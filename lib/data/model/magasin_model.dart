
class MagasinsResponse {
  MagasinsResponse({
    this.statusCode,
    this.codeText,
    this.message,
    this.corps,
  });

  String? statusCode;
  String? codeText;
  String? message;
  Magasin?corps;// Contiendra les données des produits avec pagination

  factory MagasinsResponse.fromJson(Map<String, dynamic> json) =>
      MagasinsResponse(
        statusCode: json["statusCode"],
        codeText: json["codeText"],
        message: json["message"],
        corps: json["data"] != null ? Magasin.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "codeText": codeText,
    "message": message,
    "data": corps?.toJson(),
  };
}

class Magasin {
  final String id;
  final String code;
  final String nom;
  final String adresse;
  final String contact;
  final String logoUrl;
  final String email;

  Magasin({
    required this.id,
    required this.code,
    required this.nom,
    required this.adresse,
    required this.contact,
    required this.logoUrl,
    required this.email,
  });

  factory Magasin.fromJson(Map<String, dynamic> json) {
    return Magasin(
      id: json['id'] as String,
      code: json['code'] as String,
      nom: json['nom'] as String,
      adresse: json['adresse'] as String,
      contact: json['contact'] as String,
      logoUrl: json['logoUrl'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'nom': nom,
      'adresse': adresse,
      'contact': contact,
      'logoUrl': logoUrl,
      'email': email,
    };
  }
}
