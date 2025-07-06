import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mvmnt_cli/app/main_app.dart';
import 'package:mvmnt_cli/services/config/remote_config.dart';
import 'package:mvmnt_cli/core/storage/hive/hive_init.dart';
import 'firebase_options.dart';
import 'core/di/injection_container.dart';
import 'package:mvmnt_cli/services/analytics/analytics_service.dart';
import 'package:mvmnt_cli/services/error/crash_reporting_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDependencies();

  await HiveInit.initialize();

  await serviceLocator<CrashReportingService>().initialize();
  await serviceLocator<AnalyticsService>().initialize();
  await serviceLocator<RemoteConfig>().initialize();

  runApp(const MainApp());
}
