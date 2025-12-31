import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'qstate.dart';
import 'package:flutter_riverpod/legacy.dart';
final qprovider = StateNotifierProvider<QNotifier,Qstate>((ref){
  return QNotifier();
});
class QNotifier extends StateNotifier<Qstate> {
  QNotifier() : super(Qstate());
  void setAge(int age){
      state = state.copyWith(age: age);
  }
  void setGender(String gender){
    state = state.copyWith(gender : gender);

  }
  void setWeight(double weight){
    state = state.copyWith(weight : weight);

  }
  void setHeight(double height){
    state = state.copyWith(height : height);

  }
  void setBodyType(String bodyType){
    state = state.copyWith(bodyType : bodyType);

  }
  void setGoal(String goal){
    state = state.copyWith(goal : goal);

  }
  void nextStep(){
    if(state.step==0 && state.age==null){
      return;
    }                         
    if(state.step==1 && state.gender==null){
      return;
    }
    if(state.step==2 && state.weight==null){
      return;
    }
    if(state.step==3 && state.height==null){
      return;
    }
    if(state.step==4 && state.bodyType==null){
      return;
    }
    if(state.step==5 && state.goal==null){
      return;
    }

    state = state.copyWith(step: state.step+1);
  }
  void previousStep(){
    if(state.step==0){
      return;
    }
    state = state.copyWith(step: state.step-1);
  }

  
}
