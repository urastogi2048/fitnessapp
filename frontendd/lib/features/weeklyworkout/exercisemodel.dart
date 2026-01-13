enum BodyPart {
  chest,
  back,
  legs,
  arms,
  shoulders,
  core,
  cardio,
}
class Exercise {
  final String name;
  final BodyPart bodypart;
  final String animation;
  final int duration;
  Exercise({
    required this.name,
    required this.bodypart,
    required this.animation,
    required this.duration,
  });

}