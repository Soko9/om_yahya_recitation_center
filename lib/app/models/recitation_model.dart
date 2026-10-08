class RecitationModel {
  const new({
    required this.id,
    required this.tenantId,
    required this.recitedAt,
    required this.rewayah,
    required this.qPart,
    required this.surahId,
    required this.startQVerse,
    required this.endQVerse,
    required this.reciteScore,
    required this.tajweedScore,
    required this.memoryScore,
    this.notes,
  });

  factory fromMap(Map<String, dynamic> map) {
    return RecitationModel(
      id: map['id'] as int,
      tenantId: map['tenant_id'] as int,
      recitedAt: DateTime.parse(map['recited_at'] as String),
      rewayah: map['rewayah'] as String,
      qPart: map['q_part'] as int,
      surahId: map['surah_id'] as int,
      startQVerse: map['start_q_verse'] as int,
      endQVerse: map['end_q_verse'] as int,
      reciteScore: map['recite_score'] as int,
      tajweedScore: map['tajweed_score'] as int,
      memoryScore: map['memory_score'] as int,
      notes: map['notes'] as String?,
    );
  }

  final int id;
  final int tenantId;
  final DateTime recitedAt;
  final String rewayah;
  final int qPart;
  final int surahId;
  final int startQVerse;
  final int endQVerse;
  final int reciteScore;
  final int tajweedScore;
  final int memoryScore;
  final String? notes;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'recited_at': recitedAt.toIso8601String(),
      'rewayah': rewayah,
      'q_part': qPart,
      'surah_id': surahId,
      'start_q_verse': startQVerse,
      'end_q_verse': endQVerse,
      'recite_score': reciteScore,
      'tajweed_score': tajweedScore,
      'memory_score': memoryScore,
      'notes': notes,
    };
  }
}
