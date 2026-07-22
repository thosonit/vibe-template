import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'env.dart';

/// Typed accessor over `.env` values — read once at startup in `main.dart`
/// before `runApp`, via [AppConfig.load].
///
/// No raw `dotenv.env['KEY']` access is allowed outside this file.
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.apiTimeout,
    required this.isDebug,
  });

  final String apiBaseUrl;
  final Duration apiTimeout;
  final bool isDebug;

  static Future<AppConfig> load({bool isDebug = false}) async {
    await dotenv.load(fileName: '.env');

    final timeoutMs = int.tryParse(dotenv.env[Env.apiTimeoutMs] ?? '') ?? 15000;

    return AppConfig(
      apiBaseUrl: dotenv.env[Env.apiBaseUrl] ?? '',
      apiTimeout: Duration(milliseconds: timeoutMs),
      isDebug: isDebug,
    );
  }
}
