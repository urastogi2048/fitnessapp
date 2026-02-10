class Qstate {
  int step;
  int? age;
  String? gender;
  double? weight;
  double? height;
  String? bodyType;
  String? goal;
  Qstate({
    this.step = 0,
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.bodyType,
    this.goal,
  });
  Qstate copyWith({
    int? step,
    int? age,
    String? gender,
    double? weight,
    double? height,
    String? bodyType,
    String? goal,
  }) {
    return Qstate(
      step: step ?? this.step,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      goal: goal ?? this.goal,
    );
  }
}
