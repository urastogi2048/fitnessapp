import 'package:frontendd/core/tokenstorage.dart';
import 'package:frontendd/services/apiservices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/authprovider.dart';
class StreakData {
  final int currentStreak;
  final int longestStreak;
  final String? lastWorkoutDay;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    this.lastWorkoutDay,
  });
  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastWorkoutDay: json['lastWorkoutDay'],
    );
  }
}
class StreakService {
  final ApiService api;
  StreakService(this.api);
  Future<StreakData> fetchStreak() async {
    final token = await TokenStorage.getToken();
    if(token==null){
      throw Exception("Not authenticated");
    }
    final data=await api.get('/workout/streak',token: token);
    final payload = data['streak'] ?? data;
    return StreakData.fromJson(payload as Map<String, dynamic>);
  }
}
final streakServiceProvider = Provider<StreakService>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return StreakService(apiService);
});
final streakProvider = FutureProvider<StreakData>((ref) async {
  final service=ref.read(streakServiceProvider);
  return service.fetchStreak();
});