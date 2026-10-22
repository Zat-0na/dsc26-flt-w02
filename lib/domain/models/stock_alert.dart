enum Severity { critical, high, medium, low }

final class StockAlert {
  final String id;
  final String medicineNameEn;
  final String medicineNameAr;
  final Severity severity;
  final double daysOfCover;
  final String branchCode;
  final bool acknowledged;

  const StockAlert({
    required this.id,
    required this.medicineNameEn,
    required this.medicineNameAr,
    required this.severity,
    required this.daysOfCover,
    required this.branchCode,
    this.acknowledged = false,
  });

  factory StockAlert.fromJson(Map<String, Object?> json) {
    String requiredString(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('$key must be a non-empty string');
      }
      return value;
    }

    final rawSeverity = json['severity'];
    if (rawSeverity is! String) {
      throw const FormatException('severity must be a string');
    }

    final severityValue = rawSeverity.toLowerCase();
    final severity = Severity.values.where(
      (value) => value.name == severityValue,
    );

    if (severity.isEmpty) {
      throw FormatException('Invalid severity: $rawSeverity');
    }

    final rawDays = json['daysOfCover'];

    if (rawDays is! num || !rawDays.isFinite || rawDays < 0) {
      throw const FormatException(
        'daysOfCover must be a finite, non-negative number',
      );
    }

    final rawAcknowledged = json['acknowledged'];
    if (rawAcknowledged != null && rawAcknowledged is! bool) {
      throw const FormatException('acknowledged must be a bool');
    }

    return StockAlert(
      id: requiredString('id'),
      medicineNameEn: requiredString('medicineNameEn'),
      medicineNameAr: requiredString('medicineNameAr'),
      branchCode: requiredString('branchCode'),
      severity: severity.first,
      daysOfCover: rawDays.toDouble(),
      acknowledged: rawAcknowledged as bool? ?? false,
    );
  }

  StockAlert copyWith({
    String? id,
    String? medicineNameEn,
    String? medicineNameAr,
    Severity? severity,
    double? daysOfCover,
    String? branchCode,
    bool? acknowledged,
  }) {
    return StockAlert(
      id: id ?? this.id,
      medicineNameEn: medicineNameEn ?? this.medicineNameEn,
      medicineNameAr: medicineNameAr ?? this.medicineNameAr,
      severity: severity ?? this.severity,
      daysOfCover: daysOfCover ?? this.daysOfCover,
      branchCode: branchCode ?? this.branchCode,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockAlert &&
          other.id == id &&
          other.medicineNameEn == medicineNameEn &&
          other.medicineNameAr == medicineNameAr &&
          other.severity == severity &&
          other.daysOfCover == daysOfCover &&
          other.branchCode == branchCode &&
          other.acknowledged == acknowledged;

  @override
  int get hashCode => Object.hash(
    id,
    medicineNameEn,
    medicineNameAr,
    severity,
    daysOfCover,
    branchCode,
    acknowledged,
  );
}
