import 'package:freezed_annotation/freezed_annotation.dart';
import 'exercisemodel.dart';

part 'workout_session_state.freezed.dart';

@freezed
class WorkoutSessionState with _$WorkoutSessionState {
  const factory WorkoutSessionState({
    required List<Exercise> exercises,
    required int currentExerciseIndex,
    required int timeRemaining,
    required int totalTimeSpent,
    required bool isPlaying,
    required bool isCompleted,
    required BodyPart bodyPart,
    required Map<String, int> exerciseTimings,
    required bool isInCooldown,
    required int cooldownTimeRemaining,
  }) = _WorkoutSessionState;

  factory WorkoutSessionState.initial({
    required List<Exercise> exercises,
    required BodyPart bodyPart,
    
  }) =>
      WorkoutSessionState(
        exercises: exercises,
        currentExerciseIndex: 0,
        timeRemaining: exercises.isNotEmpty ? exercises[0].duration : 0,
        totalTimeSpent: 0,
        isPlaying: false,
        isCompleted: false,
        bodyPart: bodyPart,
        exerciseTimings: {},
        isInCooldown: false,
        cooldownTimeRemaining: 15,
      );
}