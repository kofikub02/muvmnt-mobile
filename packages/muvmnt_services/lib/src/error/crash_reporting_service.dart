abstract class CrashReportingService {
  /// Initialize the crash reporting service
  Future<void> initialize();

  /// Log a non-fatal error with a custom message
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  });

  /// Log custom keys and values that will be included in crash reports
  Future<void> setCustomKey(String key, dynamic value);

  /// Log user identifier to associate crash reports with specific users
  Future<void> setUserIdentifier(String identifier);

  /// Log specific message without an error
  Future<void> log(String message);

  /// Enable or disable collection of crash reports
  Future<void> setCrashlyticsCollectionEnabled(bool enabled);
}
