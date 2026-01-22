import 'package:flutter_riverpod/legacy.dart' show StateProvider;
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


final cachedStreakProvider = StateProvider<StreakData?>((ref) => null);

final streakProvider = FutureProvider<StreakData>((ref) async {
  final service = ref.read(streakServiceProvider);
  final cached = ref.read(cachedStreakProvider);
  final fetched = await service.fetchStreak();

  StreakData resolved = fetched;

  if (fetched.currentStreak == 0 && fetched.lastWorkoutDay != null) {
    final lastDay = DateTime.tryParse(fetched.lastWorkoutDay!);
    if (lastDay != null && cached != null && cached.currentStreak > 0) {
      final daysSince = DateTime.now()
          .difference(DateTime(lastDay.year, lastDay.month, lastDay.day))
          .inDays;

      if (daysSince <= 1) {
        resolved = StreakData(
          currentStreak: cached.currentStreak,
          longestStreak: fetched.longestStreak,
          lastWorkoutDay: fetched.lastWorkoutDay,
        );
      }
    }
  }

  // Update cache for future reads.
  ref.read(cachedStreakProvider.notifier).state = resolved;
  return resolved;
});