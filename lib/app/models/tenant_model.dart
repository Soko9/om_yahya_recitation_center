class TenantModel {
  const new({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.joinedAt,
    this.avgScoreFromHundred = 0,
    this.latestSurahNumber = 1,
    this.latestQPart = 1,
    this.latestQVerse = 1,
  });

  factory fromMap(Map<String, dynamic> map) {
    return TenantModel(
      id: map['id'] as int,
      firstName: map['first_name'] as String,
      middleName: map['middle_name'] as String,
      lastName: map['last_name'] as String,
      joinedAt: DateTime.parse(map['joined_at'] as String),
      avgScoreFromHundred: map['avg_score_from_hundred'] as int? ?? 0,
      latestSurahNumber: map['latest_surah_number'] as int? ?? 1,
      latestQPart: map['latest_q_part'] as int? ?? 1,
      latestQVerse: map['latest_q_verse'] as int? ?? 1,
    );
  }

  final int id;
  final String firstName;
  final String middleName;
  final String lastName;
  final DateTime joinedAt;
  final int avgScoreFromHundred;
  final int latestSurahNumber;
  final int latestQPart;
  final int latestQVerse;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'joined_at': joinedAt.toIso8601String(),
      'avg_score_from_hundred': avgScoreFromHundred,
      'latest_surah_number': latestSurahNumber,
      'latest_q_part': latestQPart,
      'latest_q_verse': latestQVerse,
    };
  }
}
