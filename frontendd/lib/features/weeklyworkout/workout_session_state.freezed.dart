// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WorkoutSessionState {
  List<Exercise> get exercises => throw _privateConstructorUsedError;
  int get currentExerciseIndex => throw _privateConstructorUsedError;
  int get timeRemaining => throw _privateConstructorUsedError;
  int get totalTimeSpent => throw _privateConstructorUsedError;
  bool get isPlaying => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  BodyPart get bodyPart => throw _privateConstructorUsedError;
  Map<String, int> get exerciseTimings => throw _privateConstructorUsedError;
  bool get isInCooldown => throw _privateConstructorUsedError;
  int get cooldownTimeRemaining => throw _privateConstructorUsedError;

  /// Create a copy of WorkoutSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkoutSessionStateCopyWith<WorkoutSessionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutSessionStateCopyWith<$Res> {
  factory $WorkoutSessionStateCopyWith(
    WorkoutSessionState value,
    $Res Function(WorkoutSessionState) then,
  ) = _$WorkoutSessionStateCopyWithImpl<$Res, WorkoutSessionState>;
  @useResult
  $Res call({
    List<Exercise> exercises,
    int currentExerciseIndex,
    int timeRemaining,
    int totalTimeSpent,
    bool isPlaying,
    bool isCompleted,
    BodyPart bodyPart,
    Map<String, int> exerciseTimings,
    bool isInCooldown,
    int cooldownTimeRemaining,
  });
}

/// @nodoc
class _$WorkoutSessionStateCopyWithImpl<$Res, $Val extends WorkoutSessionState>
    implements $WorkoutSessionStateCopyWith<$Res> {
  _$WorkoutSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkoutSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercises = null,
    Object? currentExerciseIndex = null,
    Object? timeRemaining = null,
    Object? totalTimeSpent = null,
    Object? isPlaying = null,
    Object? isCompleted = null,
    Object? bodyPart = null,
    Object? exerciseTimings = null,
    Object? isInCooldown = null,
    Object? cooldownTimeRemaining = null,
  }) {
    return _then(
      _value.copyWith(
            exercises: null == exercises
                ? _value.exercises
                : exercises // ignore: cast_nullable_to_non_nullable
                      as List<Exercise>,
            currentExerciseIndex: null == currentExerciseIndex
                ? _value.currentExerciseIndex
                : currentExerciseIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            timeRemaining: null == timeRemaining
                ? _value.timeRemaining
                : timeRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTimeSpent: null == totalTimeSpent
                ? _value.totalTimeSpent
                : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                      as int,
            isPlaying: null == isPlaying
                ? _value.isPlaying
                : isPlaying // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            bodyPart: null == bodyPart
                ? _value.bodyPart
                : bodyPart // ignore: cast_nullable_to_non_nullable
                      as BodyPart,
            exerciseTimings: null == exerciseTimings
                ? _value.exerciseTimings
                : exerciseTimings // ignore: cast_nullable_to_non_nullable
                      as Map<String, int>,
            isInCooldown: null == isInCooldown
                ? _value.isInCooldown
                : isInCooldown // ignore: cast_nullable_to_non_nullable
                      as bool,
            cooldownTimeRemaining: null == cooldownTimeRemaining
                ? _value.cooldownTimeRemaining
                : cooldownTimeRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WorkoutSessionStateImplCopyWith<$Res>
    implements $WorkoutSessionStateCopyWith<$Res> {
  factory _$$WorkoutSessionStateImplCopyWith(
    _$WorkoutSessionStateImpl value,
    $Res Function(_$WorkoutSessionStateImpl) then,
  ) = __$$WorkoutSessionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<Exercise> exercises,
    int currentExerciseIndex,
    int timeRemaining,
    int totalTimeSpent,
    bool isPlaying,
    bool isCompleted,
    BodyPart bodyPart,
    Map<String, int> exerciseTimings,
    bool isInCooldown,
    int cooldownTimeRemaining,
  });
}

/// @nodoc
class __$$WorkoutSessionStateImplCopyWithImpl<$Res>
    extends _$WorkoutSessionStateCopyWithImpl<$Res, _$WorkoutSessionStateImpl>
    implements _$$WorkoutSessionStateImplCopyWith<$Res> {
  __$$WorkoutSessionStateImplCopyWithImpl(
    _$WorkoutSessionStateImpl _value,
    $Res Function(_$WorkoutSessionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WorkoutSessionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exercises = null,
    Object? currentExerciseIndex = null,
    Object? timeRemaining = null,
    Object? totalTimeSpent = null,
    Object? isPlaying = null,
    Object? isCompleted = null,
    Object? bodyPart = null,
    Object? exerciseTimings = null,
    Object? isInCooldown = null,
    Object? cooldownTimeRemaining = null,
  }) {
    return _then(
      _$WorkoutSessionStateImpl(
        exercises: null == exercises
            ? _value._exercises
            : exercises // ignore: cast_nullable_to_non_nullable
                  as List<Exercise>,
        currentExerciseIndex: null == currentExerciseIndex
            ? _value.currentExerciseIndex
            : currentExerciseIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        timeRemaining: null == timeRemaining
            ? _value.timeRemaining
            : timeRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTimeSpent: null == totalTimeSpent
            ? _value.totalTimeSpent
            : totalTimeSpent // ignore: cast_nullable_to_non_nullable
                  as int,
        isPlaying: null == isPlaying
            ? _value.isPlaying
            : isPlaying // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        bodyPart: null == bodyPart
            ? _value.bodyPart
            : bodyPart // ignore: cast_nullable_to_non_nullable
                  as BodyPart,
        exerciseTimings: null == exerciseTimings
            ? _value._exerciseTimings
            : exerciseTimings // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        isInCooldown: null == isInCooldown
            ? _value.isInCooldown
            : isInCooldown // ignore: cast_nullable_to_non_nullable
                  as bool,
        cooldownTimeRemaining: null == cooldownTimeRemaining
            ? _value.cooldownTimeRemaining
            : cooldownTimeRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$WorkoutSessionStateImpl implements _WorkoutSessionState {
  const _$WorkoutSessionStateImpl({
    required final List<Exercise> exercises,
    required this.currentExerciseIndex,
    required this.timeRemaining,
    required this.totalTimeSpent,
    required this.isPlaying,
    required this.isCompleted,
    required this.bodyPart,
    required final Map<String, int> exerciseTimings,
    required this.isInCooldown,
    required this.cooldownTimeRemaining,
  }) : _exercises = exercises,
       _exerciseTimings = exerciseTimings;

  final List<Exercise> _exercises;
  @override
  List<Exercise> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  final int currentExerciseIndex;
  @override
  final int timeRemaining;
  @override
  final int totalTimeSpent;
  @override
  final bool isPlaying;
  @override
  final bool isCompleted;
  @override
  final BodyPart bodyPart;
  final Map<String, int> _exerciseTimings;
  @override
  Map<String, int> get exerciseTimings {
    if (_exerciseTimings is EqualUnmodifiableMapView) return _exerciseTimings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_exerciseTimings);
  }

  @override
  final bool isInCooldown;
  @override
  final int cooldownTimeRemaining;

  @override
  String toString() {
    return 'WorkoutSessionState(exercises: $exercises, currentExerciseIndex: $currentExerciseIndex, timeRemaining: $timeRemaining, totalTimeSpent: $totalTimeSpent, isPlaying: $isPlaying, isCompleted: $isCompleted, bodyPart: $bodyPart, exerciseTimings: $exerciseTimings, isInCooldown: $isInCooldown, cooldownTimeRemaining: $cooldownTimeRemaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutSessionStateImpl &&
            const DeepCollectionEquality().equals(
              other._exercises,
              _exercises,
            ) &&
            (identical(other.currentExerciseIndex, currentExerciseIndex) ||
                other.currentExerciseIndex == currentExerciseIndex) &&
            (identical(other.timeRemaining, timeRemaining) ||
                other.timeRemaining == timeRemaining) &&
            (identical(other.totalTimeSpent, totalTimeSpent) ||
                other.totalTimeSpent == totalTimeSpent) &&
            (identical(other.isPlaying, isPlaying) ||
                other.isPlaying == isPlaying) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.bodyPart, bodyPart) ||
                other.bodyPart == bodyPart) &&
            const DeepCollectionEquality().equals(
              other._exerciseTimings,
              _exerciseTimings,
            ) &&
            (identical(other.isInCooldown, isInCooldown) ||
                other.isInCooldown == isInCooldown) &&
            (identical(other.cooldownTimeRemaining, cooldownTimeRemaining) ||
                other.cooldownTimeRemaining == cooldownTimeRemaining));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_exercises),
    currentExerciseIndex,
    timeRemaining,
    totalTimeSpent,
    isPlaying,
    isCompleted,
    bodyPart,
    const DeepCollectionEquality().hash(_exerciseTimings),
    isInCooldown,
    cooldownTimeRemaining,
  );

  /// Create a copy of WorkoutSessionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutSessionStateImplCopyWith<_$WorkoutSessionStateImpl> get copyWith =>
      __$$WorkoutSessionStateImplCopyWithImpl<_$WorkoutSessionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _WorkoutSessionState implements WorkoutSessionState {
  const factory _WorkoutSessionState({
    required final List<Exercise> exercises,
    required final int currentExerciseIndex,
    required final int timeRemaining,
    required final int totalTimeSpent,
    required final bool isPlaying,
    required final bool isCompleted,
    required final BodyPart bodyPart,
    required final Map<String, int> exerciseTimings,
    required final bool isInCooldown,
    required final int cooldownTimeRemaining,
  }) = _$WorkoutSessionStateImpl;

  @override
  List<Exercise> get exercises;
  @override
  int get currentExerciseIndex;
  @override
  int get timeRemaining;
  @override
  int get totalTimeSpent;
  @override
  bool get isPlaying;
  @override
  bool get isCompleted;
  @override
  BodyPart get bodyPart;
  @override
  Map<String, int> get exerciseTimings;
  @override
  bool get isInCooldown;
  @override
  int get cooldownTimeRemaining;

  /// Create a copy of WorkoutSessionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkoutSessionStateImplCopyWith<_$WorkoutSessionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
