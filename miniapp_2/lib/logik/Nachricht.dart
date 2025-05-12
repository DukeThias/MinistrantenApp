class Nachricht {
  final String art;
  final String inhalt;
  final DateTime timestamp;

  Nachricht({required this.art, required this.inhalt, required this.timestamp});

  factory Nachricht.fromJson(Map<String, dynamic> json) {
    return Nachricht(
      art: json['art'],
      inhalt: json['inhalt'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'art': art,
      'inhalt': inhalt,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
