import 'exercisemodel.dart';

class ExerciseData {
  static List<Exercise> getExercises(BodyPart bodyPart, {String? goal}) {
    
    final normalizedGoal = goal?.toLowerCase() ?? '';

    switch (bodyPart) {
      case BodyPart.chest:
        if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Barbell Bench Press x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Barbell Bench Press x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Barbell Bench Press x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Barbell Bench Press x4',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Inclined Dumbell Press x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
            Exercise(
              name: 'Inclined Dumbell Press x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
            Exercise(
              name: 'Inclined Dumbell Press x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
            Exercise(
              name: 'Inclined Dumbell Press x4',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,
            ),
            Exercise(
              name: 'Flat Dumbell Press x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Flat Dumbell Press x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Flat Dumbell Press x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Flat Dumbell Press x4',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Cable Flyes x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),
               Exercise(
              name: 'Cable Flyes x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),
               Exercise(
              name: 'Cable Flyes x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),
               Exercise(
              name: 'Weighted Dips x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),
              Exercise(
              name: 'Weighted Dips x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),Exercise(
              name: 'Weighted Dips x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),
              Exercise(
              name: 'PushUps x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),
              Exercise(
              name: 'PushUps x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 40,  
              ),


                        

            
            
            
          ];
        } else if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Push Ups x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups x4',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
            Exercise(
              name: 'Dumbell Press x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x4',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),

            
            
          ];
        } else {
       
          return [
            Exercise(
              name: 'Dumbell Press x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Inclined PushUps x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
             Exercise(
              name: 'Inclined PushUps x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ), Exercise(
              name: 'Inclined PushUps x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ), Exercise(
              name: 'Inclined PushUps x4',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 45,
            ),
             Exercise(
              name: 'Peck Deck Fly x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Peck Deck Fly x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Peck Deck Fly x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Shoulder Tap Plank x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Shoulder Tap Plank x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Shoulder Tap Plank x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Fly x1',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
             Exercise(
              name: 'Resistance Band Fly x2',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
             Exercise(
              name: 'Resistance Band Fly x3',
              bodypart: BodyPart.chest,
              animation: 'assets/lottie/Fitness.json',
              duration: 30,
            ),
          ];
        }

      case BodyPart.legs:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Bodyweight Squats x1',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x2',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x3',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x4',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 45,
            ),
            Exercise(
              name: 'Jump Squats x1',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 35,
            ),
            Exercise(
              name: 'Jump Squats x2',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 35,
            ),Exercise(
              name: 'Jump Squats x3',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 35,
            ),Exercise(
              name: 'Jump Squats x4',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 35,
            ),
            Exercise(
              name: 'Alternating Lunges x1',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),
            Exercise(
              name: 'Alternating Lunges x2',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),Exercise(
              name: 'Alternating Lunges x3',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),Exercise(
              name: 'Alternating Lunges x4',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),
            Exercise(
              name: 'High Knees x1',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),Exercise(
              name: 'High Knees x2',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),Exercise(
              name: 'High Knees x3',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),Exercise(
              name: 'High Knees x4',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 40,
            ),
            Exercise(
              name: 'Sled Push x1',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 30,
            ),
             Exercise(
              name: 'Sled Push x2',
              bodypart: BodyPart.legs,
              animation: 'assets/lottie/Lunge.json',
              duration: 30,
            ), Exercise(
              name: 'Sled Push x3',
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