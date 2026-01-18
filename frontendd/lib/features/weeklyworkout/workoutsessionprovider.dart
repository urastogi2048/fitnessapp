import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:frontendd/services/apiservices.dart';
import 'package:frontendd/core/tokenstorage.dart';
import 'package:state_notifier/state_notifier.dart';
import 'workout_session_state.dart';
import 'exercisemodel.dart';

class WorkoutSessionNotifier extends StateNotifier<WorkoutSessionState> {
    Timer? timer;
    final ApiService apiService;
    WorkoutSessionNotifier(
      List<Exercise> exercises,
      BodyPart bodyPart,
      this.apiService, 
    ): super(WorkoutSessionState.initial(
      exercises:exercises,
      bodyPart: bodyPart, 
    ));
    void startTimer(){
      if(state.isCompleted) return;
      state = state.copyWith(isPlaying: true);
      timer?.cancel();
      
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        
        if(state.isInCooldown){
          if(state.cooldownTimeRemaining > 0){
            state = state.copyWith(
              cooldownTimeRemaining: state.cooldownTimeRemaining - 1,
              totalTimeSpent: state.totalTimeSpent + 1,
            );
          } else {
            
            if(state.currentExerciseIndex < state.exercises.length - 1){
              final nextIndex = state.currentExerciseIndex + 1;
              state = state.copyWith(
                currentExerciseIndex: nextIndex,
                timeRemaining: state.exercises[nextIndex].duration,
                isInCooldown: false,
                cooldownTimeRemaining: 15,
                isPlaying: true,
              );
            }
          }
        }
        // Handle exercise mode
        else {
          if(state.timeRemaining > 0){
            state = state.copyWith(
              timeRemaining: state.timeRemaining - 1,
              totalTimeSpent: state.totalTimeSpent + 1,
            );
            
            // Update per-exercise timing
            final currentExercise = state.exercises[state.currentExerciseIndex];
            final currentTiming = state.exerciseTimings[currentExercise.name] ?? 0;
            state = state.copyWith(
              exerciseTimings: {
                ...state.exerciseTimings,
                currentExercise.name: currentTiming + 1,
              },
            );
          } else {
            // Exercise finished, check if more exercises
            if(state.currentExerciseIndex < state.exercises.length - 1){
              // Enter cooldown mode
              state = state.copyWith(
                isInCooldown: true,
                cooldownTimeRemaining: 15,
                isPlaying: true,
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
    void pauseTimer(){
      timer?.cancel();
      state = state.copyWith(isPlaying: false);
    }

    void nextExercise(){
      if(state.currentExerciseIndex<state.exercises.length -1){
        final nextIndex = state.currentExerciseIndex +1;
        timer?.cancel();
        state = state.copyWith(
          currentExerciseIndex: nextIndex,
          timeRemaining: state.exercises[nextIndex].duration,
          isPlaying: false,
          isInCooldown: false,
          cooldownTimeRemaining: 15,
        );
      }
    }
    void previousExercise(){
      if(state.currentExerciseIndex>0) {
        final newIndex = state.currentExerciseIndex - 1;
        timer?.cancel();
        state = state.copyWith(
          currentExerciseIndex: newIndex,
          timeRemaining: state.exercises[newIndex].duration,
          isPlaying: false,
        );
      }
    }
    void entercooldown(){
      state = state.copyWith(
        isInCooldown: true,
        cooldownTimeRemaining: 15,
      );
    }

      
    Future<void> completeWorkout() async {
      timer?.cancel();
      state = state.copyWith(isCompleted: true);
      print('🏋️ WORKOUT COMPLETED - Starting to save...');
      print('   Total time: ${state.totalTimeSpent}s');
      print('   Body part: ${state.bodyPart.name}');
      
      try{
        final token = await TokenStorage.getToken();
        print('   Token: ${token != null ? "✅ Found" : "❌ Not found"}');
        
        if(token!=null){
          print('   Sending POST to /workout/log...');
          final response = await apiService.post(
            '/workout/log',
            {
              'duration': state.totalTimeSpent,
              'bodyPart': state.bodyPart.name,
            },
            token: token,
          );
          print('✅ Workout logged successfully: $response');
        } else {
          print('❌ Token is null - cannot save workout');
        }
      }
      catch(e){
        print('❌ Error logging workout: $e');
        print('   Stack trace: $e');
      }
    }
    @override 
    void dispose(){
      timer?.cancel();
      super.dispose();
    }
    }
    final workoutSessionProvider = StateNotifierProvider.family<WorkoutSessionNotifier, WorkoutSessionState, ({
  List<Exercise> exercises,   BodyPart bodyPart
    })> (
  (ref, params) => WorkoutSessionNotifier(
    params.exercises,
    params.bodyPart,
    ApiService(),
  ),

  
    );