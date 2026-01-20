import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/services/authservice.dart';
class RecoveryState {
  double sleep_hours;
  int sleep_quality;
  int fatigue_level;
  int  muscle_soreness;
  double  prev_day_intensity;
  int workout_streak;
  int resting_hr;

  RecoveryState({
    required this.sleep_hours,
    required this.sleep_quality,
    required this.fatigue_level,
    required this.muscle_soreness,
    required this.prev_day_intensity,
    required this.workout_streak,
    required this.resting_hr,
  });

  factory RecoveryState.fromJson(Map<String,dynamic> json){
    return RecoveryState(
      sleep_hours: (json['sleep_hours'] as num).toDouble(),
      sleep_quality: json['sleep_quality'] as int,
      fatigue_level: json['fatigue_level'] as int,
      muscle_soreness: json['muscle_soreness'] as int,
      prev_day_intensity: (json['prev_day_intensity'] as num).toDouble(),
      workout_streak: json['workout_streak'] as int,
      resting_hr: json['resting_hr'] as int,
    );
  }

}
class RecoveryReadiness {
  final double overallscore;
  // final String recommendation;
  // final String message;
  // final Map<String,double> metricScores;
 
  RecoveryReadiness({
    required this.overallscore,
    // required this.recommendation,
    // required this.message,
    // required this.metricScores,
   
  });
  factory RecoveryReadiness.fromJson(Map<String,dynamic> json)  {
    return RecoveryReadiness(
      overallscore: (json['overallscore'] as num).toDouble(),

    );
  
  }
  String get recommendation {
    if (overallscore >= 80) return 'Intense';
    if (overallscore >= 60) return 'Moderate';
    if (overallscore >= 40) return 'Light';
    return 'Rest';
  }


  String get message {
    if (overallscore >= 80) return 'You\'re fully recovered! Go for a challenging workout ';
    if (overallscore >= 60) return 'Good recovery. Moderate intensity workout recommended ';
    if (overallscore >= 40) return 'Below optimal recovery. Light activity recommended ';
    return 'Recovery is poor. Consider rest or very light activity ';
  }

}

class RecoveryService {
  final AuthService authService;
  RecoveryService(this.authService);
  
  Future<RecoveryReadiness> fetchRecoveryReadiness(Map<String, dynamic> userMetrics) async {
    try {
      final response = await authService.getRecoveryMetrics(userMetrics);
      return RecoveryReadiness.fromJson(response);
    } catch(e) {
      throw Exception('Failed to fetch recovery readiness: $e');
    }
  }
}
final recoveryServiceProvider = Provider<RecoveryService>((ref) {
  final authService = ref.read(authServiceProvider);
  return RecoveryService(authService);
});
final recoveryReadinessProvider = FutureProvider.autoDispose.family<RecoveryReadiness, Map<String, dynamic>>((ref, userMetrics) async {
  final service = ref.watch(recoveryServiceProvider);
  return await service.fetchRecoveryReadiness(userMetrics);
});