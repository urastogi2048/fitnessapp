import 'exercisemodel.dart';

class ExerciseData {
  static List<Exercise> getExercises(BodyPart bodyPart) {
    switch (bodyPart) {
      case BodyPart.chest:
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
      case BodyPart.legs:
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
      case BodyPart.back:
        return [
          Exercise(
            name: 'Superman',
            bodypart: BodyPart.back,
            animation: 'assets/lottie/Fitness.json',
            duration: 40,
          ),
        ];
      case BodyPart.arms:
        return [
          Exercise(
            name: 'Tricep Dips',
            bodypart: BodyPart.arms,
            animation: 'assets/lottie/Fitness.json',
            duration: 40,
          ),
        ];
      case BodyPart.shoulders:
        return [
          Exercise(
            name: 'Pike Push Ups',
            bodypart: BodyPart.shoulders,
            animation: 'assets/lottie/Fitness.json',
            duration: 40,
          ),
        ];
      case BodyPart.core:
        return [
          Exercise(
            name: 'Plank',
            bodypart: BodyPart.core,
            animation: 'assets/lottie/Fitness.json',
            duration: 60,
          ),
        ];
      case BodyPart.cardio:
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