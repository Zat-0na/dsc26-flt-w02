import 'package:flutter/material.dart';

import 'package:dsc26_flt_w02/data/repositories/alert_repository.dart';
import 'package:dsc26_flt_w02/domain/models/stock_alert.dart';
import 'package:dsc26_flt_w02/ui/alerts/view_models/alerts_view_model.dart';
import 'package:dsc26_flt_w02/ui/alerts/widgets/alerts_screen.dart';

void main() {
  runApp(NourShelfApp(repository: InMemoryAlertRepository(demoAlerts)));
}

/// A few alerts for running the app by hand (`flutter run`).
const List<StockAlert> demoAlerts = [
  StockAlert(
    id: 'insulin',
    medicineNameEn: 'Insulin glargine',
    medicineNameAr: 'انسولين جلارجين',
    severity: Severity.critical,
    daysOfCover: 2,
    branchCode: 'CAI-014',
  ),
  StockAlert(
    id: 'levo',
    medicineNameEn: 'Levothyroxine 50 mcg',
    medicineNameAr: 'ليفوثيروكسين ٥٠ ميكروجرام',
    severity: Severity.high,
    daysOfCover: 6,
    branchCode: 'CAI-014',
  ),
  StockAlert(
    id: 'amox',
    medicineNameEn: 'Amoxicillin syrup',
    medicineNameAr: 'شراب أموكسيسيلين',
    severity: Severity.medium,
    daysOfCover: 9,
    branchCode: 'CAI-014',
  ),
  StockAlert(
    id: 'vitd',
    medicineNameEn: 'Vitamin D3 drops',
    medicineNameAr: 'نقط فيتامين د',
    severity: Severity.low,
    daysOfCover: 30,
    branchCode: 'CAI-014',
  ),
];

/// The app root.
class NourShelfApp extends StatefulWidget {
  const NourShelfApp({super.key, required this.repository});

  final AlertRepository repository;

  @override
  State<NourShelfApp> createState() => _NourShelfAppState();
}

class _NourShelfAppState extends State<NourShelfApp> {
  late final AlertsViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // Create the ViewModel only once.
    _viewModel = AlertsViewModel(repository: widget.repository);

    // The app, not the screen, starts loading.
    _viewModel.load();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nour Shelf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315D8A)),
        scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      ),
      home: AlertsScreen(viewModel: _viewModel),
    );
  }
}
