class FastingProtocol {
  final String name;
  final Duration fastingDuration;
  final Duration eatingDuration;

  const FastingProtocol({
    required this.name,
    required this.fastingDuration,
    required this.eatingDuration,
  });

  factory FastingProtocol.custom(int fastingHours) {
    final eatingHours = 24 - fastingHours;

    return FastingProtocol(
      name: '$fastingHours:$eatingHours',
      fastingDuration: Duration(hours: fastingHours),
      eatingDuration: Duration(hours: eatingHours),
    );
  }

  static const List<FastingProtocol> protocols = [
    FastingProtocol(
      name: '12:12',
      fastingDuration: Duration(hours: 12),
      eatingDuration: Duration(hours: 12),
    ),
    FastingProtocol(
      name: '16:8',
      fastingDuration: Duration(hours: 16),
      eatingDuration: Duration(hours: 8),
    ),
    FastingProtocol(
      name: '18:6',
      fastingDuration: Duration(hours: 18),
      eatingDuration: Duration(hours: 6),
    ),
  ];
}
