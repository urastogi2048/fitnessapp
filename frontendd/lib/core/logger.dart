/// Centralized logger.
///
/// Logging is intentionally disabled to keep debug console output clean.
class Logger {
  static void debug(String message) {
    // Intentionally no-op: debug logs disabled.
  }

  static void info(String message) {
    // Intentionally no-op: info logs disabled.
  }

  static void warn(String message) {
    // Intentionally no-op: warning logs disabled.
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    // Intentionally no-op: error logs disabled.
  }
}
