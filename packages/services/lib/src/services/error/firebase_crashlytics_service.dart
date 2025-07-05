import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:mvmnt_cli/services/error/crash_reporting_service.dart';

class FirebaseCrashlyticsService implements CrashReportingService {
  final FirebaseCrashlytics crashlytics;

  FirebaseCrashlyticsService({required this.crashlytics});

  @override
  Future<void> initialize() async {
    // Pass all uncaught Flutter errors to Crashlytics
    FlutterError.onError = crashlytics.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    // Only enable Crashlytics in non-debug mode
    await setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
  }) async {
    await crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: false,
    );
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    await crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    await crashlytics.setUserIdentifier(identifier);
  }

  @override
  Future<void> log(String message) async {
    await crashlytics.log(message);
  }

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await crashlytics.setCrashlyticsCollectionEnabled(enabled);
  }
}
