import 'package:flutter/foundation.dart';

import '../../../data/repositories/alert_repository.dart';
import '../../../domain/models/stock_alert.dart';

class AlertsViewModel extends ChangeNotifier {
  AlertsViewModel({required AlertRepository repository})
    : _repository = repository;

  final AlertRepository _repository;

  List<StockAlert> _alerts = [];
  bool _loading = false;
  final Set<Severity> _activeFilters = {};
  String _query = '';

  bool get loading => _loading;

  Set<Severity> get activeFilters => Set<Severity>.unmodifiable(_activeFilters);

  List<StockAlert> get visibleAlerts {
    final normalizedQuery = _normalize(_query);

    final filtered = _alerts.where((alert) {
      final matchesSeverity =
          _activeFilters.isEmpty || _activeFilters.contains(alert.severity);

      final matchesQuery =
          normalizedQuery.isEmpty ||
          _normalize(alert.medicineNameEn).contains(normalizedQuery) ||
          _normalize(alert.medicineNameAr).contains(normalizedQuery);

      return matchesSeverity && matchesQuery;
    }).toList();

    filtered.sort(_compareAlerts);

    return List<StockAlert>.unmodifiable(filtered);
  }

  int get unacknowledgedCriticalCount => _alerts
      .where(
        (alert) => alert.severity == Severity.critical && !alert.acknowledged,
      )
      .length;

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    try {
      final alerts = await _repository.fetchAlerts();
      _alerts = List<StockAlert>.of(alerts);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void toggleFilter(Severity severity) {
    if (_activeFilters.contains(severity)) {
      _activeFilters.remove(severity);
    } else {
      _activeFilters.add(severity);
    }

    notifyListeners();
  }

  void setQuery(String query) {
    if (_query == query) {
      return;
    }

    _query = query;
    notifyListeners();
  }

  Future<void> acknowledge(String id) async {
    final index = _alerts.indexWhere((alert) => alert.id == id);

    // An unknown ID must not call the repository or change the state.
    if (index == -1) {
      return;
    }

    // Acknowledge through the repository first.
    await _repository.acknowledge(id);

    // Update the local state only after the operation succeeds.
    final currentIndex = _alerts.indexWhere((alert) => alert.id == id);

    if (currentIndex == -1) {
      return;
    }

    final updatedAlerts = List<StockAlert>.of(_alerts);

    updatedAlerts[currentIndex] = updatedAlerts[currentIndex].copyWith(
      acknowledged: true,
    );

    _alerts = updatedAlerts;
    notifyListeners();
  }

  static int _compareAlerts(StockAlert a, StockAlert b) {
    // Unacknowledged alerts appear first.
    final acknowledgedComparison = a.acknowledged.toString().compareTo(
      b.acknowledged.toString(),
    );

    if (acknowledgedComparison != 0) {
      return acknowledgedComparison;
    }

    // Severity order: critical, high, medium, low.
    final severityComparison = _severityRank(a.severity)
        .compareTo(_severityRank(b.severity));

    if (severityComparison != 0) {
      return severityComparison;
    }

    // Fewer days of cover come first.
    final coverComparison = a.daysOfCover.compareTo(b.daysOfCover);

    if (coverComparison != 0) {
      return coverComparison;
    }

    // Final tie-breaker: English medicine name, case-insensitive.
    return a.medicineNameEn.toLowerCase().compareTo(
      b.medicineNameEn.toLowerCase(),
    );
  }

  static int _severityRank(Severity severity) {
    switch (severity) {
      case Severity.critical:
        return 0;
      case Severity.high:
        return 1;
      case Severity.medium:
        return 2;
      case Severity.low:
        return 3;
    }
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('\u0640', '')
        .replaceAll(RegExp(r'[\u064B-\u0652]'), '');
  }
}
