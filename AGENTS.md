
# AGENTS.md

## Project
- This is the Nour Shelf Flutter application.
- Keep changes focused on the requested feature; avoid unrelated refactoring.
- Follow the existing layered structure: domain, data, and UI.

## Flutter and State Management
- Use the Flutter SDK constraint declared in `pubspec.yaml` (expected: >=3.47.6 <3.48.0).
- Use the existing Provider + ChangeNotifier approach for screen state.
- Keep UI state and filtering logic in `AlertsViewModel`, not inside widgets.
- Do not introduce Bloc, Riverpod, or another state-management solution.

## Architecture
- `lib/domain/models/stock_alert.dart`: alert model and JSON parsing.
- `lib/data/repositories/alert_repository.dart`: alert data access contract.
- `lib/ui/alerts/view_models/alerts_view_model.dart`: loading, filtering, and visible alerts.
- `lib/ui/alerts/widgets/alerts_screen.dart`: alerts screen UI.
- Keep data access out of UI widgets.
- Expose read-only or unmodifiable collections when callers must not mutate internal state.
- Convert invalid alert data into clear parsing errors; do not silently accept malformed fields.

## UI
- Reuse existing alert widgets and styles before creating new components.
- Preserve existing screen keys and accessibility labels.
- Keep severity colors and selected-filter text readable with sufficient contrast.
- Check the existing theme files before changing colors or typography.

## Commands
- Install dependencies: `flutter pub get`
- Run static checks: `flutter analyze`
- Run public tests: `flutter test test/public_test.dart`
- Run all tests: `flutter test`
- Run the app: `flutter run`
- Build Android APK: `flutter build apk`

## Safety and Scope
- Never add API keys, passwords, tokens, or personal data to source files.
- Do not change dependency versions unless the task requires it.
- Do not claim tests pass unless you ran them and checked the result.
- Check existing permission and offline-handling behavior before changing platform code.
- Avoid adding permissions or platform configuration without a demonstrated requirement.
- If a required project detail is unclear, inspect the existing implementation before assuming.
