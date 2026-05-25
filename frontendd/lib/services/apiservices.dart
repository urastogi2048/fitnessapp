import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:frontendd/core/network_exception.dart';

class ApiService {
  static const String baseUrl = "https://fitnessdude.duckdns.org";
  static const Duration timeout = Duration(seconds: 30);

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl$endpoint"),
            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(
            timeout,
            onTimeout: () {
              throw NetworkException('Request timeout - no internet connection');
            },
          );

      if (response.statusCode >= 400) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorData["error"] ?? 'Error: ${response.statusCode}',
          );
        } catch (e) {
          throw Exception('Error: ${response.statusCode} - ${response.body}');
        }
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } on NetworkException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException('No internet connection: $e');
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl$endpoint"),
            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authorization": "Bearer $token",
            },
          )
          .timeout(
            timeout,
            onTimeout: () {
              throw NetworkException('Request timeout - no internet connection');
            },
          );

      if (response.statusCode >= 400) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorData["error"] ?? 'Error: ${response.statusCode}',
          );
        } catch (e) {
          throw Exception('Error: ${response.statusCode} - ${response.body}');
        }
      }

      final data = jsonDecode(response.body);
      return data;
    } on NetworkException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException('No internet connection: $e');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl$endpoint"),
            headers: {
              "Content-Type": "application/json",
              if (token != null) "Authorization": "Bearer $token",
            },
            body: jsonEncode(body),
          )
          .timeout(
            timeout,
            onTimeout: () {
              throw NetworkException('Request timeout - no internet connection');
            },
          );

      if (response.statusCode >= 400) {
        try {
          final errorData = jsonDecode(response.body) as Map<String, dynamic>;
          throw Exception(
            errorData["error"] ?? 'Error: ${response.statusCode}',
          );
        } catch (e) {
          throw Exception('Error: ${response.statusCode} - ${response.body}');
        }
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data;
    } on NetworkException {
      rethrow;
    } on SocketException catch (e) {
      throw NetworkException('No internet connection: $e');
    } catch (e) {
      rethrow;
    }
  }
}
