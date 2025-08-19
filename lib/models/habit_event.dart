class HabitEvent {
  final int? id; // optional because DB will auto-generate
  final String name; // e.g. "Tea", "Gym", "Call Mom"
  final DateTime timestamp;
  final double? lat; // optional GPS
  final double? lng; // optional GPS

  HabitEvent({
    this.id,
    required this.name,
    required this.timestamp,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'timestamp': timestamp.toIso8601String(),
      'lat': lat,
      'lng': lng,
    };
  }

  factory HabitEvent.fromMap(Map<String, dynamic> map) {
    return HabitEvent(
      id: map['id'] as int?,
      name: map['name'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      lat: (map['lat'] as num?)?.toDouble(),
      lng: (map['lng'] as num?)?.toDouble(),
    );
  }
}
