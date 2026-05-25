class Qstate {
  int step;
  int? age;
  String? gender;
  double? weight;
  double? height;
  String? bodyType;
  String? goal;
  String? errorMessage;
  
  Qstate({
    this.step = 0,
    this.age,
    this.gender,
    this.weight,
    this.height,
    this.bodyType,
    this.goal,
    this.errorMessage,
  });
  Qstate copyWith({
    int? step,
    int? age,
    String? gender,
    double? weight,
    double? height,
    String? bodyType,
    String? goal,
    String? errorMessage,
  }) {
    return Qstate(
      step: step ?? this.step,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bodyType: bodyType ?? this.bodyType,
      goal: goal ?? this.goal,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
