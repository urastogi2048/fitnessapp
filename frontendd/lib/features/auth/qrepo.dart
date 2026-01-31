import 'package:frontendd/services/apiservices.dart';
import 'package:frontendd/core/tokenstorage.dart';

class QRepo {
  final ApiService _api = ApiService();
  Future <void> saveProfile ({
    required int age,
    required String gender,
    required double weight,
    required double height,
    required String bodyType,
    required String goal,

  }) async {
    await _api.post(
      "/user/profile",
      {
        "age": age,
        "gender": gender,
        "weight": weight,
        "height": height,
        "bodyType": bodyType,
        "goal": goal,

      },
      token: await TokenStorage.getToken(),

    );
  }
  Future<Map<String, dynamic>> fetchProfile() async {
    return await _api.get(
      "/user/profile",
      token: await TokenStorage.getToken(),
    );
  }
  Future<void> updateProfile ({
    required int age,
    required String gender,
    required double weight,
    required double height,
    required String bodyType,
    required String goal,

  }) async {
    await _api.put(
      "/user/profile",
      {
        "age" :age,
        "gender": gender,
        "weight": weight,
        "height": height,
        "bodyType": bodyType,
        "goal": goal,
      },
      token: await TokenStorage.getToken(),
    );
  }
}
