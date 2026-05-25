import 'package:frontendd/core/tokenstorage.dart';
import 'package:frontendd/core/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'apiservices.dart';

class AuthService {
  final ApiService api;
  static const String _recoveryUrl =
      'https://recoveryscore.duckdns.org/predict';
  AuthService(this.api);
  Future<void> signup(String username, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();
    Logger.debug('AuthService.signup called for: ${normalizedEmail.length > 4 ? normalizedEmail.substring(0,4) + '...' : normalizedEmail}');
    await api.post("/auth/signup", {
      "username": username,
      "email": normalizedEmail,
      "password": trimmedPassword,
    });
    Logger.info('AuthService.signup succeeded for: ${normalizedEmail.length > 4 ? normalizedEmail.substring(0,4) + '...' : normalizedEmail}');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedPassword = password.trim();
    Logger.debug('AuthService.login called for: ${normalizedEmail.length > 4 ? normalizedEmail.substring(0,4) + '...' : normalizedEmail}');
    final data = await api.post("/auth/login", {
      "email": normalizedEmail,
      "password": trimmedPassword,
    });
    Logger.info('AuthService.login request completed for: ${normalizedEmail.length > 4 ? normalizedEmail.substring(0,4) + '...' : normalizedEmail}');
    return data;
  }

  Future<Map<String, dynamic>> getMe() async {
    final token = await TokenStorage.getToken();

    Logger.debug('AuthService.getMe() called');
    Logger.debug('Token from storage: ${token != null ? "EXISTS" : "NULL/MISSING"}');

    if (token == null) {
      throw Exception('No authentication token found. Please login again.');
    }

    return await api.get("/user/me", token: token);
  }

  Future<Map<String, dynamic>> getRecoveryMetrics(
    Map<String, dynamic> userMetrics,
  ) async {
    Logger.debug('AuthService.getRecoveryMetrics() called');
    try {
      // Call external ML service
      final response = await http.post(
        Uri.parse(_recoveryUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userMetrics),
      );
      Logger.debug('Recovery ML service status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to get recovery score: ${response.statusCode} ${response.reasonPhrase}',
        );
      }

      final responseBody = response.body.trim();

      double? score;
      try {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map<String, dynamic>) {
          if (decoded['overallscore'] is num) {
            score = (decoded['overallscore'] as num).toDouble();
          } else if (decoded['score'] is num) {
            score = (decoded['score'] as num).toDouble();
          }
        } else if (decoded is num) {
          score = decoded.toDouble();
        }
      } catch (_) {
        // fall through to regex parsing
      }

      score ??= _firstNumberFromString(responseBody);
      if (score == null) {
        throw Exception('Could not parse recovery score from response');
      }

      return {"overallscore": score};
    } catch (e) {
      Logger.error('Error calling ML service', e, null);
      throw Exception('Failed to fetch recovery metrics');
    }
  }

  double? _firstNumberFromString(String input) {
    final match = RegExp(r'[-+]?[0-9]*\.?[0-9]+').firstMatch(input);
    if (match == null) return null;
    return double.tryParse(match.group(0) ?? '');
  }
}
