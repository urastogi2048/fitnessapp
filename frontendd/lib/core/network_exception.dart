/// Exception thrown when network-related errors occur
/// This is distinct from authentication errors
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
