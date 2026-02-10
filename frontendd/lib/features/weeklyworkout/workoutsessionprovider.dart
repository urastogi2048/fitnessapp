import 'dart:async';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:frontendd/services/apiservices.dart';
import 'package:frontendd/core/tokenstorage.dart';
import 'package:state_notifier/state_notifier.dart';
import 'workout_session_state.dart';
import 'exercisemodel.dart';
import 'package:frontendd/services/soundservice.dart';

class WorkoutSessionNotifier extends StateNotifier<WorkoutSessionState> {
  Timer? timer;
  Timer? saveTimer;
  final ApiService apiService;
  int lastSavedTime = 0;
  final WorkoutSoundService soundService = WorkoutSoundService();
  WorkoutSessionNotifier(
    List<Exercise> exercises,
    BodyPart bodyPart,
    this.apiService,
  ) : super(
        WorkoutSessionState.initial(exercises: exercises, bodyPart: bodyPart),
      );

  void startTimer() {
    if (state.isCompleted) return;

    // Cancel any existing timers first
    timer?.cancel();
    timer = null;
    saveTimer?.cancel();
    saveTimer = null;

    state = state.copyWith(isPlaying: true);
    soundService.playBackgroundMusic();

    // Start periodic save timer (every 10 seconds)
    saveTimer = Timer.periodic(Duration(seconds: 10), (_) {
      _saveProgressIncremental();
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.isInCooldown) {
        if (state.cooldownTimeRemaining > 0) {
          state = state.copyWith(
            cooldownTimeRemaining: state.cooldownTimeRemaining - 1,
            totalTimeSpent: state.totalTimeSpent + 1,
          );
        } else {
          if (state.currentExerciseIndex < state.exercises.length - 1) {
            final nextIndex = state.currentExerciseIndex + 1;
            // Only resume music if it was playing before cooldown
            if (state.isPlaying) {
              soundService.resumeBackgroundMusic();
            }
            state = state.copyWith(
              currentExerciseIndex: nextIndex,
              timeRemaining: state.exercises[nextIndex].duration,
              isInCooldown: false,
              cooldownTimeRemaining: 45,
              isPlaying: state.isPlaying,
            );
          }
        }
      } else {
        if (state.timeRemaining > 0) {
          state = state.copyWith(
            timeRemaining: state.timeRemaining - 1,
            totalTimeSpent: state.totalTimeSpent + 1,
          );

          final currentExercise = state.exercises[state.currentExerciseIndex];
          final currentTiming =
              state.exerciseTimings[currentExercise.name] ?? 0;
          state = state.copyWith(
            exerciseTimings: {
              ...state.exerciseTimings,
              currentExercise.name: currentTiming + 1,
            },
          );
        } else {
          // Exercise finished, check if more exercises
          if (state.currentExerciseIndex < state.exercises.length - 1) {
            // Pause music during cooldown/rest
            soundService.pauseBackgroundMusic();
            // Enter cooldown mode
            state = state.copyWith(
              isInCooldown: true,
              cooldownTimeRemaining: 45,
              isPlaying: state.isPlaying,
            );
          } else {
            // Last exercise done, complete workout
            timer.cancel();
            completeWorkout();
          }
        }
      }
    });
  }

  void pauseTimer() {
    // Cancel timers first
    timer?.cancel();
    timer = null;
    saveTimer?.cancel();
    saveTimer = null;

    // Pause music
    soundService.pauseBackgroundMusic();

    // Update state
    state = state.copyWith(isPlaying: false);

    // Save progress when pausing
    _saveProgressIncremental();
  }

  void nextExercise() {
    if (state.currentExerciseIndex < state.exercises.length - 1) {
      final nextIndex = state.currentExerciseIndex + 1;
      timer?.cancel();
      soundService.pauseBackgroundMusic();
      state = state.copyWith(
        currentExerciseIndex: nextIndex,
        timeRemaining: state.exercises[nextIndex].duration,
        isPlaying: false,
        isInCooldown: false,
        cooldownTimeRemaining: 45,
      );
    }
  }

  void previousExercise() {
    if (state.currentExerciseIndex > 0) {
      final newIndex = state.currentExerciseIndex - 1;
      timer?.cancel();
      soundService.pauseBackgroundMusic();
      state = state.copyWith(
        currentExerciseIndex: newIndex,
        timeRemaining: state.exercises[newIndex].duration,
        isPlaying: false,
      );
    }
  }

  void entercooldown() {
    state = state.copyWith(isInCooldown: true, cooldownTimeRemaining: 45);
  }

  Future<void> _saveProgressIncremental() async {
    final timeToSave = state.totalTimeSpent - lastSavedTime;
    if (timeToSave <= 0) return;

    print(' Saving incremental progress: ${timeToSave}s');

    try {
      final token = await TokenStorage.getToken();

      if (token != null) {
        await apiService.post('/workout/log', {
          'duration': timeToSave,
          'bodyPart': state.bodyPart.name,
        }, token: token);
        lastSavedTime = state.totalTimeSpent;
        print('✅ Progress saved (${timeToSave}s)');
      }
    } catch (e) {
      print('❌ Error saving progress: $e');
    }
  }

  Future<void> completeWorkout() async {
    timer?.cancel();
    saveTimer?.cancel();
    soundService.stopBackgroundMusic();
    await _saveProgressIncremental();

    state = state.copyWith(isCompleted: true);
    print('WORKOUT COMPLETED');
  }

  @override
  void dispose() {
    timer?.cancel();
    saveTimer?.cancel();
    soundService.dispose();
    _saveProgressIncremental();
    super.dispose();
  }
}

final workoutSessionProvider =
    StateNotifierProvider.family<
      WorkoutSessionNotifier,
      WorkoutSessionState,
      ({List<Exercise> exercises, BodyPart bodyPart})
    >(
      (ref, params) => WorkoutSessionNotifier(
        params.exercises,
        params.bodyPart,
        ApiService(),
      ),
    );
