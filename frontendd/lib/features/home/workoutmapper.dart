import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:frontendd/features/weeklyworkout/exercisemodel.dart';

import 'package:state_notifier/state_notifier.dart';
class WeeklyPlanNotifier extends StateNotifier<List<String>>{
  static const String _key='weekly_workout_plan';
  
  WeeklyPlanNotifier() : super([
    'CHEST DAY',       // Monday (index 0)
    'BACK DAY',        // Tuesday
    'LEG DAY',         // Wednesday
    'SHOULDERS DAY',   // Thursday
    'ARMS DAY',        // Friday
    'CORE + CARDIO DAY', // Saturday
    'REST DAY',  
  ]){_loadPlan();}

  Future<void> _loadPlan() async {
    final prefs=await SharedPreferences.getInstance();
    final String? plan=prefs.getString(_key);
    if(plan!=null){
      final List<dynamic> decoded=jsonDecode(plan);
      state=decoded.cast<String>();
    }
  }

  Future<void> updateDay(int index, String newValue) async {
    final newPlan=[...state];
    newPlan[index]=newValue;
    state=newPlan;
    final prefs=await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state));
   
  }
 

  }

   final weeklyPlanProvider=StateNotifierProvider<WeeklyPlanNotifier, List<String>>((ref){
    return WeeklyPlanNotifier();
  });
  class Workoutmapper {
    static const List<String> allworkouttypes=[
      'CHEST DAY',
      'BACK DAY',
      'LEG DAY',
      'SHOULDERS DAY',
      'ARMS DAY',
      'CORE + CARDIO DAY',
      'REST DAY',

    ];
    static BodyPart? getBodyPart(String workoutType){
      switch(workoutType){
        case 'CHEST DAY':
          return BodyPart.chest;
        case 'BACK DAY':
          return BodyPart.back;
        case 'LEG DAY':
          return BodyPart.legs;
        case 'SHOULDERS DAY':
          return BodyPart.shoulders;
        case 'ARMS DAY':
          return BodyPart.arms;
        case 'CORE + CARDIO DAY':
          return BodyPart.core;
        case 'REST DAY':
          return null;
        default:
          return null;
      }
    }
    static String getDisplayName(String workoutType){
      return workoutType.replaceAll(' DAY', '');
    }
  }