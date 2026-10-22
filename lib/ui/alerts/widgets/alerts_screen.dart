import 'package:flutter/material.dart';

import 'package:dsc26_flt_w02/domain/models/stock_alert.dart';
import 'package:dsc26_flt_w02/ui/alerts/view_models/alerts_view_model.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key, required this.viewModel});

  final AlertsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text(
          'Nour Shelf',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: const Color(0xFF243447),
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          final alerts = viewModel.visibleAlerts;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Branch alerts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF243447),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Monitor medicine stock across your branch.',
                        style: TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 16),

                      // Search is forwarded directly to the ViewModel.
                      TextField(
                        key: const Key('search-field'),
                        onChanged: viewModel.setQuery,
                        decoration: InputDecoration(
                          hintText: 'Search medicines...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // The widget displays filters; the ViewModel applies them.
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: Severity.values.map((severity) {
                          final selected = viewModel.activeFilters.contains(
                            severity,
                          );

                          return FilterChip(
                            key: Key('filter-${severity.name}'),
                            label: Text(
                              _severityLabel(severity),
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: selected,
                            selectedColor: const Color(0xFF1A73E8),
                            checkmarkColor: Colors.white,
                            backgroundColor: Colors.white,
                            onSelected: (_) => viewModel.toggleFilter(severity),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 12),

                      // Count comes from the ViewModel's visible list.
                      Text(
                        '${alerts.length} ${alerts.length == 1 ? 'alert' : 'alerts'}',
                        key: const Key('alerts-count'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF243447),
                        ),
                      ),
                    ],
                  ),
                ),

                if (viewModel.loading)
                  const Expanded(
                    child: Center(
                      child: Column(
                        key: Key('alerts-loading'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Loading alerts...'),
                        ],
                      ),
                    ),
                  )
                else if (alerts.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          key: Key('alerts-empty'),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_none,
                              size: 48,
                              color: Colors.black38,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No alerts found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try changing your search or filters.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      key: const Key('alerts-list'),
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                      itemCount: alerts.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final alert = alerts[index];

                        return _AlertCard(
                          key: Key('alert-${alert.id}'),
                          alert: alert,
                          onAcknowledge: alert.acknowledged
                              ? null
                              : () {
                                  viewModel.acknowledge(alert.id);
                                },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _severityLabel(Severity severity) {
    switch (severity) {
      case Severity.critical:
        return 'Critical';
      case Severity.high:
        return 'High';
      case Severity.medium:
        return 'Medium';
      case Severity.low:
        return 'Low';
    }
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    super.key,
    required this.alert,
    required this.onAcknowledge,
  });

  final StockAlert alert;
  final VoidCallback? onAcknowledge;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(alert.severity);

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: color.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    alert.medicineNameEn,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF243447),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _severityLabel(alert.severity),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              alert.medicineNameAr,
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 6,
              children: [
                _InfoLabel(
                  icon: Icons.store_outlined,
                  text: 'Branch ${alert.branchCode}',
                ),
                _InfoLabel(
                  icon: Icons.inventory_2_outlined,
                  text: '${alert.daysOfCover} days of cover',
                ),
              ],
            ),
            if (onAcknowledge != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  key: Key('ack-${alert.id}'),
                  onPressed: onAcknowledge,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Acknowledge'),
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.check_circle, size: 17, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    'Acknowledged',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _severityLabel(Severity severity) {
    switch (severity) {
      case Severity.critical:
        return 'Critical';
      case Severity.high:
        return 'High';
      case Severity.medium:
        return 'Medium';
      case Severity.low:
        return 'Low';
    }
  }

  static Color _severityColor(Severity severity) {
    switch (severity) {
      case Severity.critical:
        return Colors.red.shade700;
      case Severity.high:
        return Colors.deepOrange.shade700;
      case Severity.medium:
        return Colors.orange.shade800;
      case Severity.low:
        return Colors.blue.shade700;
    }
  }
}

class _InfoLabel extends StatelessWidget {
  const _InfoLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }
}
