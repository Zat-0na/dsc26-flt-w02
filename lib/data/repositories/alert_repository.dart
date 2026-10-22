import '../../domain/models/stock_alert.dart';

/// The source of truth for stock alerts.
abstract class AlertRepository {
  Future<List<StockAlert>> fetchAlerts();

  Future<void> acknowledge(String alertId);
}

/// A repository that keeps alerts in memory.
class InMemoryAlertRepository implements AlertRepository {
  InMemoryAlertRepository(List<StockAlert> alerts) : _alerts = List.of(alerts);

  final List<StockAlert> _alerts;

  /// Every acknowledged ID, in call order.
  final List<String> acknowledgedIds = <String>[];

  @override
  Future<List<StockAlert>> fetchAlerts() async => List.of(_alerts);

  @override
  Future<void> acknowledge(String alertId) async {
    acknowledgedIds.add(alertId);
  }
}
