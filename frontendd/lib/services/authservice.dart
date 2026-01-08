import 'package:frontendd/core/tokenstorage.dart';

import 'apiservices.dart';
class AuthService{
   final ApiService api;
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

}