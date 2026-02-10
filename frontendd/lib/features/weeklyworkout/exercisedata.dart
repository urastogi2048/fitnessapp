import 'exercisemodel.dart';
import 'exercise_animations.dart';

class ExerciseData {
  static List<Exercise> getExercises(BodyPart bodyPart, {String? goal}) {
    final normalizedGoal = goal?.toLowerCase() ?? '';

    switch (bodyPart) {
      case BodyPart.chest:
        if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Push-ups x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Push-ups x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Push-ups x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Push-ups x4',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Elevated Push-ups x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.elevatedPushup,
              duration: 40,
            ),
            Exercise(
              name: 'Elevated Push-ups x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.elevatedPushup,
              duration: 40,
            ),
            Exercise(
              name: 'Elevated Push-ups x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.elevatedPushup,
              duration: 40,
            ),
            Exercise(
              name: 'Elevated Push-ups x4',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.elevatedPushup,
              duration: 40,
            ),
            Exercise(
              name: 'Flat Dumbbell Press x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Flat Dumbbell Press x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Flat Dumbbell Press x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Flat Dumbbell Press x4',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Chest Fly x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.resistanceBandFly,
              duration: 40,
            ),
            Exercise(
              name: 'Resistance Band Chest Fly x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.resistanceBandFly,
              duration: 40,
            ),
            Exercise(
              name: 'Resistance Band Chest Fly x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.resistanceBandFly,
              duration: 40,
            ),
            Exercise(
              name: 'Chair Dips x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dips,
              duration: 40,
            ),
            Exercise(
              name: 'Chair Dips x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dips,
              duration: 40,
            ),
            Exercise(
              name: 'Chair Dips x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dips,
              duration: 40,
            ),
            Exercise(
              name: 'PushUps x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'PushUps x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
          ];
        } else if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Push Ups x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Push Ups x4',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Dumbell Press x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x4',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Dumbell Press x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbell Press x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellPress,
              duration: 35,
            ),
            Exercise(
              name: 'Inclined PushUps x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Inclined PushUps x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Inclined PushUps x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Inclined PushUps x4',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.pushUp,
              duration: 45,
            ),
            Exercise(
              name: 'Dumbbell Floor Fly x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellFloorFly,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Floor Fly x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellFloorFly,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Floor Fly x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.dumbbellFloorFly,
              duration: 35,
            ),
            Exercise(
              name: 'Shoulder Tap Plank x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 35,
            ),
            Exercise(
              name: 'Shoulder Tap Plank x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 35,
            ),
            Exercise(
              name: 'Shoulder Tap Plank x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Fly x1',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.resistanceBandFly,
              duration: 30,
            ),
            Exercise(
              name: 'Resistance Band Fly x2',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.resistanceBandFly,
              duration: 30,
            ),
            Exercise(
              name: 'Resistance Band Fly x3',
              bodypart: BodyPart.chest,
              animation: ExerciseAnimations.resistanceBandFly,
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
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Squats x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Jump Squats x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Jump Squats x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Jump Squats x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Alternating Lunges x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.alternatingLunges,
              duration: 40,
            ),
            Exercise(
              name: 'Alternating Lunges x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.alternatingLunges,
              duration: 40,
            ),
            Exercise(
              name: 'Alternating Lunges x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.alternatingLunges,
              duration: 40,
            ),
            Exercise(
              name: 'Alternating Lunges x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.alternatingLunges,
              duration: 40,
            ),
            Exercise(
              name: 'High Knees x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.highKnees,
              duration: 40,
            ),
            Exercise(
              name: 'High Knees x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.highKnees,
              duration: 40,
            ),
            Exercise(
              name: 'High Knees x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.highKnees,
              duration: 40,
            ),
            Exercise(
              name: 'High Knees x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.highKnees,
              duration: 40,
            ),
            Exercise(
              name: 'Bear Crawls x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.bearCrawl,
              duration: 30,
            ),
            Exercise(
              name: 'Bear Crawls x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.bearCrawl,
              duration: 30,
            ),
            Exercise(
              name: 'Bear Crawls x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.bearCrawl,
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Bodyweight Squats x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 50,
            ),
            Exercise(
              name: 'Bodyweight Squats x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),
            Exercise(
              name: 'Bodyweight Squats x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 45,
            ),

            Exercise(
              name: 'Bulgarian Split Squat x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 50,
            ),
            Exercise(
              name: 'Bulgarian Split Squat x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 50,
            ),
            Exercise(
              name: 'Bulgarian Split Squat x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 50,
            ),
            Exercise(
              name: 'Bulgarian Split Squat x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 50,
            ),
            Exercise(
              name: 'Deadlift x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.deadlift,
              duration: 40,
            ),
            Exercise(
              name: 'Deadlift x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.deadlift,
              duration: 40,
            ),
            Exercise(
              name: 'Deadlift x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.deadlift,
              duration: 40,
            ),
            Exercise(
              name: 'Deadlift x4',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.deadlift,
              duration: 40,
            ),
            Exercise(
              name: 'Walking Lunges x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 40,
            ),
            Exercise(
              name: 'Walking Lunges x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 40,
            ),
            Exercise(
              name: 'Walking Lunges x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 40,
            ),
            Exercise(
              name: 'Lying Leg Curls x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.legCurl,
              duration: 40,
            ),
            Exercise(
              name: 'Lying Leg Curls x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.legCurl,
              duration: 40,
            ),
            Exercise(
              name: 'Lying Leg Curls x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.legCurl,
              duration: 45,
            ),
            Exercise(
              name: 'Standing Calf Raises x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.calfRaise,
              duration: 45,
            ),

            Exercise(
              name: 'Standing Calf Raises x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.calfRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Standing Calf Raises x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.calfRaise,
              duration: 40,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Goblet Squat x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Goblet Squat x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Goblet Squat x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.squat,
              duration: 35,
            ),
            Exercise(
              name: 'Step-ups x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 40,
            ),
            Exercise(
              name: 'Step-ups x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 40,
            ),
            Exercise(
              name: 'Step-ups x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.lunge,
              duration: 40,
            ),
            Exercise(
              name: 'Nordic Curls x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.nordicCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Nordic Curls x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.nordicCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Nordic Curls x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.nordicCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Hip Thrust x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.hipThrust,
              duration: 40,
            ),
            Exercise(
              name: 'Hip Thrust x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.hipThrust,
              duration: 40,
            ),
            Exercise(
              name: 'Hip Thrust x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.hipThrust,
              duration: 40,
            ),
            Exercise(
              name: 'Calf Raises x1',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.calfRaise,
              duration: 45,
            ),
            Exercise(
              name: 'Calf Raises x2',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.calfRaise,
              duration: 45,
            ),
            Exercise(
              name: 'Calf Raises x3',
              bodypart: BodyPart.legs,
              animation: ExerciseAnimations.calfRaise,
              duration: 45,
            ),
          ];
        }

      case BodyPart.back:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Resistance Band Row x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Row x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Row x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Row x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Superman Hold x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.supermanHold,
              duration: 35,
            ),
            Exercise(
              name: 'Superman Hold x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.supermanHold,
              duration: 35,
            ),
            Exercise(
              name: 'Superman Hold x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.supermanHold,
              duration: 35,
            ),
            Exercise(
              name: 'Superman Hold x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.supermanHold,
              duration: 35,
            ),
            Exercise(
              name: 'Burpees x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.burpee,
              duration: 35,
            ),
            Exercise(
              name: 'Burpees x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.burpee,
              duration: 35,
            ),
            Exercise(
              name: 'Burpees x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.burpee,
              duration: 35,
            ),
            Exercise(
              name: 'Burpees x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.burpee,
              duration: 35,
            ),
            Exercise(
              name: 'Kettlebell Swings x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.kettlebellSwing,
              duration: 40,
            ),
            Exercise(
              name: 'Kettlebell Swings x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.kettlebellSwing,
              duration: 40,
            ),
            Exercise(
              name: 'Kettlebell Swings x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.kettlebellSwing,
              duration: 40,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Romanian Deadlift x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.romanianDeadlift,
              duration: 30,
            ),
            Exercise(
              name: 'Romanian Deadlift x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.romanianDeadlift,
              duration: 30,
            ),
            Exercise(
              name: 'Romanian Deadlift x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.romanianDeadlift,
              duration: 30,
            ),
            Exercise(
              name: 'Romanian Deadlift x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.romanianDeadlift,
              duration: 30,
            ),
            Exercise(
              name: 'Pull-ups x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.pullUp,
              duration: 40,
            ),
            Exercise(
              name: 'Pull-ups x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.pullUp,
              duration: 40,
            ),
            Exercise(
              name: 'Pull-ups x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.pullUp,
              duration: 40,
            ),
            Exercise(
              name: 'Pull-ups x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.pullUp,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Row x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Row x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Row x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Row x4',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pulldown x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPulldown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pulldown x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPulldown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pulldown x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPulldown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Row x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Row x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Row x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Face Pull x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.facePull,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Face Pull x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.facePull,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Face Pull x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.facePull,
              duration: 45,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Resistance Band Row x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Row x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Row x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandRow,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pulldown x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPulldown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pulldown x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPulldown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pulldown x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPulldown,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Row x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 30,
            ),
            Exercise(
              name: 'Dumbbell Row x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 30,
            ),
            Exercise(
              name: 'Dumbbell Row x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.dumbbellRow,
              duration: 30,
            ),
            Exercise(
              name: 'Back Extension x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.backExtension,
              duration: 45,
            ),
            Exercise(
              name: 'Back Extension x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.backExtension,
              duration: 45,
            ),
            Exercise(
              name: 'Back Extension x3',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.backExtension,
              duration: 45,
            ),
            Exercise(
              name: 'Band Pull-aparts x1',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPullApart,
              duration: 30,
            ),
            Exercise(
              name: 'Band Pull-aparts x2',
              bodypart: BodyPart.back,
              animation: ExerciseAnimations.bandPullApart,
              duration: 30,
            ),
          ];
        }

      case BodyPart.arms:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'DB Curl x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'DB Curl x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'DB Curl x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'DB Curl x4',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Overhead Triceps Extension x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.overheadTricepExtension,
              duration: 30,
            ),
            Exercise(
              name: 'Overhead Triceps Extension x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.overheadTricepExtension,
              duration: 30,
            ),
            Exercise(
              name: 'Overhead Triceps Extension x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.overheadTricepExtension,
              duration: 30,
            ),
            Exercise(
              name: 'Overhead Triceps Extension x4',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.overheadTricepExtension,
              duration: 30,
            ),
            Exercise(
              name: 'Jump Rope x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Jump Rope x4',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.jumpRope,
              duration: 45,
            ),
            Exercise(
              name: 'Push-ups x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Push-ups x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Push-ups x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Push-ups x4',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Shadow Boxing x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Dumbbell Curl x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Curl x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Curl x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Curl x4',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Incline DB Curl x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Incline DB Curl x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Incline DB Curl x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Skull Crushers x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.skullCrusher,
              duration: 35,
            ),
            Exercise(
              name: 'Skull Crushers x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.skullCrusher,
              duration: 35,
            ),
            Exercise(
              name: 'Skull Crushers x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.skullCrusher,
              duration: 35,
            ),
            Exercise(
              name: 'Skull Crushers x4',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.skullCrusher,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pushdown x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.resistanceBandPushdown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pushdown x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.resistanceBandPushdown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pushdown x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.resistanceBandPushdown,
              duration: 35,
            ),
            Exercise(
              name: 'Hammer Curl x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Hammer Curl x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Hammer Curl x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Chair Dips x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.dips,
              duration: 40,
            ),
            Exercise(
              name: 'Chair Dips x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.dips,
              duration: 40,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Alternating DB Curl x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Alternating DB Curl x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Alternating DB Curl x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Curl x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Resistance Band Curl x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Resistance Band Curl x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.bicepCurl,
              duration: 30,
            ),
            Exercise(
              name: 'Resistance Band Pushdown x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.resistanceBandPushdown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pushdown x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.resistanceBandPushdown,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Pushdown x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.resistanceBandPushdown,
              duration: 35,
            ),
            Exercise(
              name: 'Close Grip Push-ups x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Close Grip Push-ups x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Close Grip Push-ups x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Plank x1',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 45,
            ),
            Exercise(
              name: 'Plank x2',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 45,
            ),
            Exercise(
              name: 'Plank x3',
              bodypart: BodyPart.arms,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 45,
            ),
          ];
        }

      case BodyPart.shoulders:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Dumbbell Push Press x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Push Press x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Push Press x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Push Press x4',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Lateral Raises x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Lateral Raises x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Lateral Raises x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Lateral Raises x4',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Front Raises x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Front Raises x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Front Raises x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Front Raises x4',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Shadow Boxing x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x4',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Pike Push-ups x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.pushUp,
              duration: 35,
            ),
            Exercise(
              name: 'Pike Push-ups x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.pushUp,
              duration: 35,
            ),
            Exercise(
              name: 'Pike Push-ups x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.pushUp,
              duration: 35,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Dumbbell Overhead Press x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Overhead Press x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Overhead Press x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Overhead Press x4',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Shoulder Press x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Shoulder Press x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Dumbbell Shoulder Press x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 40,
            ),
            Exercise(
              name: 'Lateral Raises x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Lateral Raises x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Lateral Raises x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Lateral Raises x4',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Front Raises x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 30,
            ),
            Exercise(
              name: 'Front Raises x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 30,
            ),
            Exercise(
              name: 'Front Raises x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.frontRaise,
              duration: 30,
            ),
            Exercise(
              name: 'Rear Delt Fly x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.rearDeltFly,
              duration: 35,
            ),
            Exercise(
              name: 'Rear Delt Fly x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.rearDeltFly,
              duration: 35,
            ),
            Exercise(
              name: 'Rear Delt Fly x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.rearDeltFly,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Face Pull x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.facePull,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Face Pull x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.facePull,
              duration: 45,
            ),
            Exercise(
              name: 'Resistance Band Face Pull x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.facePull,
              duration: 45,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Dumbbell Shoulder Press x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Shoulder Press x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 35,
            ),
            Exercise(
              name: 'Dumbbell Shoulder Press x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 35,
            ),
            Exercise(
              name: 'Arnold Press x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 35,
            ),
            Exercise(
              name: 'Arnold Press x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 35,
            ),
            Exercise(
              name: 'Arnold Press x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.shoulderPress,
              duration: 35,
            ),
            Exercise(
              name: 'Lateral Raises x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Lateral Raises x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Lateral Raises x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.lateralRaise,
              duration: 35,
            ),
            Exercise(
              name: 'Rear Delt Fly x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.rearDeltFly,
              duration: 35,
            ),
            Exercise(
              name: 'Rear Delt Fly x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.rearDeltFly,
              duration: 35,
            ),
            Exercise(
              name: 'Rear Delt Fly x3',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.rearDeltFly,
              duration: 35,
            ),
            Exercise(
              name: 'Resistance Band Upright Row x1',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.resistanceBandUprightRow,
              duration: 30,
            ),
            Exercise(
              name: 'Resistance Band Upright Row x2',
              bodypart: BodyPart.shoulders,
              animation: ExerciseAnimations.resistanceBandUprightRow,
              duration: 30,
            ),
          ];
        }

      case BodyPart.core:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Mountain Climbers x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.mountainClimber,
              duration: 45,
            ),
            Exercise(
              name: 'Mountain Climbers x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.mountainClimber,
              duration: 45,
            ),
            Exercise(
              name: 'Mountain Climbers x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.mountainClimber,
              duration: 45,
            ),
            Exercise(
              name: 'Mountain Climbers x4',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.mountainClimber,
              duration: 45,
            ),
            Exercise(
              name: 'Plank Jacks x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.plankJacks,
              duration: 40,
            ),
            Exercise(
              name: 'Plank Jacks x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.plankJacks,
              duration: 40,
            ),
            Exercise(
              name: 'Plank Jacks x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.plankJacks,
              duration: 40,
            ),
            Exercise(
              name: 'Plank Jacks x4',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.plankJacks,
              duration: 40,
            ),
            Exercise(
              name: 'Sit-ups x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Sit-ups x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Sit-ups x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Sit-ups x4',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Flutter Kicks x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.flutterKicks,
              duration: 35,
            ),
            Exercise(
              name: 'Flutter Kicks x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.flutterKicks,
              duration: 35,
            ),
            Exercise(
              name: 'Flutter Kicks x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.flutterKicks,
              duration: 35,
            ),
            Exercise(
              name: 'Flutter Kicks x4',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.flutterKicks,
              duration: 35,
            ),
            Exercise(
              name: 'Toe Touch Crunch x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Toe Touch Crunch x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Toe Touch Crunch x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Sprint x1',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.sprint,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x2',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.sprint,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x3',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.sprint,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x4',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.sprint,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x5',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x6',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x7',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x8',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x9',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x10',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x11',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x12',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Rowing Sprint x1',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.bandRow,
              duration: 40,
            ),
            Exercise(
              name: 'Rowing Sprint x2',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.bandRow,
              duration: 40,
            ),
            Exercise(
              name: 'Rowing Sprint x3',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.bandRow,
              duration: 40,
            ),
            Exercise(
              name: 'Rowing Sprint x4',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.bandRow,
              duration: 40,
            ),
            Exercise(
              name: 'Rowing Sprint x5',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.bandRow,
              duration: 40,
            ),
            Exercise(
              name: 'Rowing Sprint x6',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.bandRow,
              duration: 40,
            ),
            Exercise(
              name: 'Battle Rope x1',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Battle Rope x2',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Battle Rope x3',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Battle Rope x4',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Battle Rope x5',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Battle Rope x6',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Stair Climber',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.walkingInPlace,
              duration: 300,
            ),
            Exercise(
              name: 'Incline Walk (cool-down)',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.walkingInPlace,
              duration: 300,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Lying Leg Raises x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Lying Leg Raises x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Lying Leg Raises x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Lying Leg Raises x4',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 40,
            ),
            Exercise(
              name: 'Crunch x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.crunch,
              duration: 45,
            ),
            Exercise(
              name: 'Crunch x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.crunch,
              duration: 45,
            ),
            Exercise(
              name: 'Crunch x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.crunch,
              duration: 45,
            ),
            Exercise(
              name: 'Ab Wheel Rollouts x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.bicycleCrunch,
              duration: 30,
            ),
            Exercise(
              name: 'Ab Wheel Rollouts x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.bicycleCrunch,
              duration: 30,
            ),
            Exercise(
              name: 'Ab Wheel Rollouts x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.bicycleCrunch,
              duration: 30,
            ),
            Exercise(
              name: 'Decline Sit-ups x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Decline Sit-ups x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Decline Sit-ups x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.sitUps,
              duration: 40,
            ),
            Exercise(
              name: 'Weighted Plank x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.plank,
              duration: 45,
            ),
            Exercise(
              name: 'Weighted Plank x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.plank,
              duration: 45,
            ),
            Exercise(
              name: 'Walking in Place',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.walkingInPlace,
              duration: 600,
            ),
            Exercise(
              name: 'High Knees',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 600,
            ),
            Exercise(
              name: 'Jumping Jacks',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.jumpingJack,
              duration: 600,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Plank x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 60,
            ),
            Exercise(
              name: 'Plank x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 60,
            ),
            Exercise(
              name: 'Plank x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 60,
            ),
            Exercise(
              name: 'Bicycle Crunch x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.crunch,
              duration: 40,
            ),
            Exercise(
              name: 'Bicycle Crunch x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.crunch,
              duration: 40,
            ),
            Exercise(
              name: 'Bicycle Crunch x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.crunch,
              duration: 40,
            ),
            Exercise(
              name: 'Leg Raises x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 45,
            ),
            Exercise(
              name: 'Leg Raises x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 45,
            ),
            Exercise(
              name: 'Leg Raises x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.legRaise,
              duration: 45,
            ),
            Exercise(
              name: 'Side Plank x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 30,
            ),
            Exercise(
              name: 'Side Plank x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 30,
            ),
            Exercise(
              name: 'Side Plank x3',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.shoulderTapPlank,
              duration: 30,
            ),
            Exercise(
              name: 'Dead Bug x1',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.bicycleCrunch,
              duration: 40,
            ),
            Exercise(
              name: 'Dead Bug x2',
              bodypart: BodyPart.core,
              animation: ExerciseAnimations.bicycleCrunch,
              duration: 40,
            ),
            Exercise(
              name: 'Jogging / Cycling',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 1800,
            ),
            Exercise(
              name: 'Jump Rope',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.jumpRope,
              duration: 300,
            ),
            Exercise(
              name: 'Cool-down Walk',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 300,
            ),
          ];
        }

      case BodyPart.cardio:
        if (normalizedGoal.contains('lose weight')) {
          return [
            Exercise(
              name: 'Sprint x1',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x2',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x3',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x4',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x5',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x6',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x7',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x8',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x9',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x10',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x11',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Sprint x12',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 30,
            ),
            Exercise(
              name: 'Burpees x1',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Burpees x2',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Burpees x3',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Burpees x4',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Burpees x5',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Burpees x6',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.pushUp,
              duration: 40,
            ),
            Exercise(
              name: 'Shadow Boxing x1',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x2',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x3',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x4',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x5',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Shadow Boxing x6',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.shadowBoxing,
              duration: 30,
            ),
            Exercise(
              name: 'Step-ups',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.stepUp,
              duration: 300,
            ),
            Exercise(
              name: 'Walking in Place (cool-down)',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.walkingInPlace,
              duration: 300,
            ),
          ];
        } else if (normalizedGoal.contains('build muscle')) {
          return [
            Exercise(
              name: 'Walking in Place',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.walkingInPlace,
              duration: 600,
            ),
            Exercise(
              name: 'High Knees',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 600,
            ),
            Exercise(
              name: 'Jumping Jacks',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.jumpingJack,
              duration: 600,
            ),
          ];
        } else {
          return [
            Exercise(
              name: 'Jogging in Place',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.joggingInPlace,
              duration: 1800,
            ),
            Exercise(
              name: 'Jump Rope',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.jumpingJack,
              duration: 300,
            ),
            Exercise(
              name: 'Cool-down Walk',
              bodypart: BodyPart.cardio,
              animation: ExerciseAnimations.highKnees,
              duration: 300,
            ),
          ];
        }
    }
  }
}
