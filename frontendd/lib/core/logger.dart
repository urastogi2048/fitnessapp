import 'package:flutter/foundation.dart';

/// Centralized logger.
///
/// - In non-release builds this prints to console using `debugPrint`.
/// - In release builds it is a no-op (prevents leaking backend or stack traces).
class Logger {
  static void debug(String message) {
    if (!kReleaseMode) debugPrint(message);
  }

  static void info(String message) {
    if (!kReleaseMode) debugPrint(message);
  }

  static void warn(String message) {
    if (!kReleaseMode) debugPrint('WARN: $message');
  }

  static void error(String message, [Object? error, StackTrace? stack]) {
    if (!kReleaseMode) {
      debugPrint('ERROR: $message');
      if (error != null) debugPrint(error.toString());
      if (stack != null) debugPrint(stack.toString());
    }
    // In release builds we intentionally avoid printing details.
  }
}
