import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage{
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  
  static Future<void> saveToken(String token) async {
    if (token.isEmpty) {
      await deleteToken();
      return;
    }
   
    await _storage.delete(key: _tokenKey);
    await Future.delayed(Duration(milliseconds: 100));
    
    await _storage.write(key: _tokenKey, value: token);
  }
  
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    // Force sync by reading immediately after
    await _storage.read(key: _tokenKey);
  }
  
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
