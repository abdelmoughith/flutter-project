class GreenProject {
  final int id;
  final String titre;
  final String? imageUrl;
  final String description;
  final String region;
  final double montantRequis;
  final double montantCollecte;
  final String statusProjet;
  final String typeEnergie;
  final int proprietaireId;
  final String proprietaireUsername;
  final DateTime dateCreation;
  final DateTime? dateValidation;
  final double? latitude;
  final double? longitude;

  GreenProject({
    required this.id,
    required this.titre,
    this.imageUrl,
    required this.description,
    required this.region,
    required this.montantRequis,
    required this.montantCollecte,
    required this.statusProjet,
    required this.typeEnergie,
    required this.proprietaireId,
    required this.proprietaireUsername,
    required this.dateCreation,
    this.dateValidation,
    this.latitude,
    this.longitude,
  });

  /// 🔁 Convert JSON → Dart object
  factory GreenProject.fromJson(Map<String, dynamic> json) {
    return GreenProject(
      id: json['id'],
      titre: json['titre'],
      imageUrl: null,
      description: json['description'],
      region: json['region'],
      montantRequis: (json['montantRequis'] as num).toDouble(),
      montantCollecte: (json['montantCollecte'] as num).toDouble(),
      statusProjet: json['statusProjet'],
      typeEnergie: json['typeEnergie'],
      proprietaireId: json['proprietaireId'],
      proprietaireUsername: json['proprietaireUsername'],
      dateCreation: DateTime.parse(json['dateCreation']),
      dateValidation: json['dateValidation'] != null
          ? DateTime.parse(json['dateValidation'])
          : null,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }
}
