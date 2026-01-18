import 'exercisemodel.dart';

class ExerciseData {
  static List<Exercise> getExercises(BodyPart bodyPart, {String? goal}) {
    
    final normalizedGoal = goal?.toLowerCase() ?? '';

    switch (bodyPart) {
      case BodyPart.chest:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Push Ups (Fast)',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
            Exercise(
              name: 'Plyometric Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 25,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups 2nd Rep',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Wide Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Diamond Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        } else {
       
          return [
            Exercise(
              name: 'Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Wide Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
            Exercise(
              name: 'Diamond Push Ups',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
          ];
        }

      case BodyPart.legs:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Jump Squats',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 35,
            ),
            Exercise(
              name: 'High Knees',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Squats',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 50,
            ),
            Exercise(
              name: 'Bulgarian Split Squats',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 50,
            ),
            Exercise(
              name: 'Lunges',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 45,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Squats',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 50,
            ),
            Exercise(
              name: 'Lunges',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 45,
            ),
          ];
        }

      case BodyPart.back:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Superman (Fast)',
              bodypart: BodyPart.back,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Superman',
              bodypart: BodyPart.back,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
            Exercise(
              name: 'Reverse Snow Angels',
              bodypart: BodyPart.back,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Superman',
              bodypart: BodyPart.back,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        }

      case BodyPart.arms:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Tricep Dips (Fast)',
              bodypart: BodyPart.arms,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Tricep Dips',
              bodypart: BodyPart.arms,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Bicep Curls (Resistance)',
              bodypart: BodyPart.arms,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Tricep Dips',
              bodypart: BodyPart.arms,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        }

      case BodyPart.shoulders:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Pike Push Ups (Fast)',
              bodypart: BodyPart.shoulders,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Pike Push Ups',
              bodypart: BodyPart.shoulders,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Shoulder Taps',
              bodypart: BodyPart.shoulders,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Pike Push Ups',
              bodypart: BodyPart.shoulders,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
          ];
        }

      case BodyPart.core:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Plank (High Intensity)',
              bodypart: BodyPart.core,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Mountain Climbers',
              bodypart: BodyPart.core,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Plank',
              bodypart: BodyPart.core,
              animation: 'assets/lottie/Fitness.json',
              duration: 60,
            ),
            Exercise(
              name: 'Side Plank',
              bodypart: BodyPart.core,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Plank',
              bodypart: BodyPart.core,
              animation: 'assets/lottie/Fitness.json',
              duration: 60,
            ),
          ];
        }

      case BodyPart.cardio:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Jumping Jacks (Fast)',
              bodypart: BodyPart.cardio,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Burpees',
              bodypart: BodyPart.cardio,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Jumping Jacks',
              bodypart: BodyPart.cardio,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Jumping Jacks',
              bodypart: BodyPart.cardio,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
          ];
        }
    }
  }
}