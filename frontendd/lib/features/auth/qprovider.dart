import 'package:flutter_riverpod/legacy.dart';
import 'qstate.dart';

class QNotifier extends StateNotifier<Qstate> {

  QNotifier() : super(Qstate(age: 18, weight: 70, height: 170));
  
  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void setWeight(double weight) {
    state = state.copyWith(weight: weight);
  }

  void setHeight(double height) {
    state = state.copyWith(height: height);
  }

  void setBodyType(String bodyType) {
    state = state.copyWith(bodyType: bodyType);
  }

  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void nextStep() {
    String? error;
    
    if (state.step == 0 && state.age == null) {
      error = 'Please select your age';
    } else if (state.step == 1 && state.gender == null) {
      error = 'Please select your gender';
    } else if (state.step == 2 && state.weight == null) {
      error = 'Please enter your weight';
    } else if (state.step == 3 && state.height == null) {
      error = 'Please enter your height';
    } else if (state.step == 4 && state.bodyType == null) {
      error = 'Please select your body type';
    } else if (state.step == 5 && state.goal == null) {
      error = 'Please select your fitness goal';
    }
    
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return;
    }
    
    state = state.copyWith(step: state.step + 1, errorMessage: null);
  }
  
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void setError(String errorMessage) {
    state = state.copyWith(errorMessage: errorMessage);
  }

  void previousStep() {
    if (state.step == 0) {
      return;
    }
    state = state.copyWith(step: state.step - 1);
  }
}

final qprovider = StateNotifierProvider<QNotifier, Qstate>((ref) {
  return QNotifier();
});
