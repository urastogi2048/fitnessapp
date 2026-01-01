import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiService{
  static const String baseUrl="https://fitnessapp-backend-fpmk.onrender.com";
  Future<Map<String, dynamic>> post(
    String endpoint, 
    Map<String,dynamic> body,  {
      String? token,
    }
  )
  async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if(token!=null) "Authorization": "Bearer $token",

      },
      body: jsonEncode(body),

    );
    final data = jsonDecode(response.body) as Map<String,dynamic>;
    if(response.statusCode>=400){
      throw Exception(data["error"] ?? 'Error: ${response.statusCode}');
    }
    return data;
  }
  Future <Map<String,dynamic>> get (
    String endpoint, {
      String? token,
    }
  ) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if(token!=null) "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body) as Map<String,dynamic>;
    if(response.statusCode>=400){
      throw Exception(data["error"] ?? 'Error: ${response.statusCode}');
    }
    return data;
  }
}