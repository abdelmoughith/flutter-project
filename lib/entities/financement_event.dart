class FinancementEvent {
  final int id;
  final int userId;
  final int projectId;
  final String message;
  final double montant;
  final DateTime dateFinancement;

  FinancementEvent({
    required this.id,
    required this.userId,
    required this.projectId,
    required this.message,
    required this.montant,
    required this.dateFinancement,
  });

  // Optional: factory constructor to parse from JSON
  factory FinancementEvent.fromJson(Map<String, dynamic> json) {
    return FinancementEvent(
      id: json['id'] as int,
      userId: json['userId'] as int,
      projectId: json['projectId'] as int,
      message: json['message'] as String,
      montant: (json['montant'] as num).toDouble(),
      dateFinancement: DateTime.parse(json['dateFinancement'] as String),
    );
  }
}
