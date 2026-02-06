import 'package:frontendd/core/tokenstorage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'apiservices.dart';
class AuthService{
   final ApiService api;
  static const String _recoveryUrl = 'https://recovery-score-backend.onrender.com/predict';
    AuthService(this.api);
    Future<void> signup (
      String username ,
      String email,
      String password,

    )async {
      await api.post("/auth/signup", {
        "username": username,
        "email": email,
        "password": password,
      });
    }

   Future<Map<String,dynamic>> login(
      String email,
      String password,
    )async {
      final data = await api.post("/auth/login", {
        "email": email,
        "password": password,
      });
      return data;
    }
   Future<Map<String, dynamic>> getMe() async {
  final token = await TokenStorage.getToken();
  
  print('🔐 AuthService.getMe() called');
  print('🔑 Token from storage: ${token != null ? "EXISTS (${token.substring(0, 30)}...)" : "NULL/MISSING"}');
  
  if (token == null) {
    throw Exception('No authentication token found. Please login again.');
  }
  
  return await api.get(
    "/user/me",
    token: token,
  );
}

   Future<Map<String, dynamic>> getRecoveryMetrics(Map<String, dynamic> userMetrics) async {
  print(' AuthService.getRecoveryMetrics() called');
  //print('POST $_recoveryUrl');
  try {
    // Call external ML service
    final response = await http.post(
      Uri.parse(_recoveryUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userMetrics),
    );
    print('status: ${response.statusCode}, body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to get recovery score: ${response.statusCode} ${response.reasonPhrase}');
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
    print('❌ Error calling ML service: $e');
    throw Exception('Failed to fetch recovery metrics: $e');
  }
}

  double? _firstNumberFromString(String input) {
    final match = RegExp(r'[-+]?[0-9]*\.?[0-9]+').firstMatch(input);
    if (match == null) return null;
    return double.tryParse(match.group(0) ?? '');
  }

}