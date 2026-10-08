import 'package:om_yahya_recitation_center/app/models/tenant_model.dart';
import 'package:om_yahya_recitation_center/core/shared/app_extensions.dart';

enum QuranRewaya {
  hafsAnAsim,
  shubahAnAsim,

  warshAnNafi,
  qalunAnNafi,

  alDuriAnAbiAmr,
  alSusiAnAbiAmr,

  alBaziiAnIbnKathir,
  qunbulAnIbnKathir,

  hishamAnIbnAmir,
  ibnDhakwanAnIbnAmir,

  shuabahAnHamzah,
  khalafAnHamzah,

  abuAlHarithAnAlKisai,
  alDuriAnAlKisai,

  ibnWardanAnAbiJafar,
  ibnJammazAnAbiJafar,

  alBaziiAnYaqub,
  rawhAnYaqub,

  ishaqAnKhalaf,
  idrisAnKhalaf,
}

class RecitationModel {
  const new({
    required this.id,
    required this.tenantId,
    required this.recitedAt,
    required this.rewayah,
    required this.qPart,
    required this.surahNumber,
    required this.startQVerse,
    required this.endQVerse,
    required this.reciteScore,
    required this.tajweedScore,
    required this.memoryScore,
    this.notes,
    this.tenant,
  });

  factory fromMap(Map<String, dynamic> map) {
    return RecitationModel(
      id: map['id'] as int,
      tenantId: map['tenant_id'] as int,
      recitedAt: DateTime.parse(map['recited_at'] as String),
      rewayah:
          QuranRewayaExtension.fromString(map['rewayah'] as String) ??
          QuranRewaya.hafsAnAsim,
      qPart: map['q_part'] as int,
      surahNumber: map['surah_number'] as int,
      startQVerse: map['start_q_verse'] as int,
      endQVerse: map['end_q_verse'] as int,
      reciteScore: map['recite_score'] as int,
      tajweedScore: map['tajweed_score'] as int,
      memoryScore: map['memory_score'] as int,
      notes: map['notes'] as String?,
      tenant: map['tenant'] != null
          ? TenantModel.fromMap(map['tenant'] as Map<String, dynamic>)
          : null,
    );
  }

  final int id;
  final int tenantId;
  final DateTime recitedAt;
  final QuranRewaya rewayah;
  final int qPart;
  final int surahNumber;
  final int startQVerse;
  final int endQVerse;
  final int reciteScore;
  final int tajweedScore;
  final int memoryScore;
  final String? notes;
  final TenantModel? tenant;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'recited_at': recitedAt.toIso8601String(),
      'rewayah': rewayah.name,
      'q_part': qPart,
      'surah_number': surahNumber,
      'start_q_verse': startQVerse,
      'end_q_verse': endQVerse,
      'recite_score': reciteScore,
      'tajweed_score': tajweedScore,
      'memory_score': memoryScore,
      'notes': notes,
    };
  }
}
