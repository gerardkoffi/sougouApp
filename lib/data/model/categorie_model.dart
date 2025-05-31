class Category {
  final int id;
  final String code;
  final String nom;
  final String description;
  final bool statut;

  Category({
    required this.id,
    required this.code,
    required this.nom,
    required this.description,
    required this.statut,
  });

  // Factory method pour créer une instance depuis un JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      nom: json['nom'] ?? '',
      description: json['description'] ?? '',
      statut: json['statut'] ?? false,
    );
  }

  // Convertir une instance en JSON
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
