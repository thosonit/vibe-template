import 'dart:developer' as developer;

/// App-wide logging wrapper — replace the body with a real logging
/// package (e.g. `logger`) if the project needs structured/remote logs.
class AppLogger {
  AppLogger._();

  static void debug(String message) => developer.log(message, name: 'DEBUG');

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(message, name: 'ERROR', error: error, stackTrace: stackTrace);
  }
}
