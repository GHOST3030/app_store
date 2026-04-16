// Failure definitions for settings data source
class SettingsFailure implements Exception {
  final String message;
  SettingsFailure(this.message);

  @override
  String toString() => 'SettingsFailure: $message';
}
