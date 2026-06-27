import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontendd/features/weeklyworkout/workout_session_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'exercisemodel.dart';
import 'workoutsessionprovider.dart';

class ExerciseExecutionPage extends ConsumerWidget {
  final List<Exercise> exercises;
  final BodyPart bodyPart;

  static const backgroundColor = Color.fromARGB(255, 20, 20, 20);
  static const surfaceColor = Color.fromARGB(255, 36, 36, 36);
  static const trackColor = Color.fromARGB(255, 30, 30, 30);
  static const accentColor = Color.fromARGB(255, 220, 50, 50);
  static const accentGlow = Color.fromARGB(255, 255, 99, 99);
  static final softAccent = Colors.orangeAccent;

  const ExerciseExecutionPage({
    super.key,
    required this.exercises,
    required this.bodyPart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(
      workoutSessionProvider((bodyPart: bodyPart, exercises: exercises)),
    );
    final sessionNotifier = ref.read(
      workoutSessionProvider((
        bodyPart: bodyPart,
        exercises: exercises,
      )).notifier,
    );

    if (sessionState.isCompleted) {
      return _buildCompletionScreen(context, sessionState);
    }
    if (sessionState.isInCooldown == true) {
      final minutes = sessionState.cooldownTimeRemaining ~/ 60;
      final seconds = sessionState.cooldownTimeRemaining % 60;
      final progress = sessionState.cooldownTimeRemaining / 45;

      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            _showExitDialog(context, sessionNotifier);
          }
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () => _showExitDialog(context, sessionNotifier),
            ),
            title: Text(
              '${bodyPart.name.toUpperCase()} WORKOUT',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
                fontSize: 18.sp,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),
                  Text(
                    'Rest Time',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 26.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Take a deep breath and get ready for the next round.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: surfaceColor),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            23,
                            15,
                            99,
                          ).withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Lottie.asset(
                            'assets/lottie/relax.json',
                            width: 220.w,
                            height: 220.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200.w,
                              height: 200.h,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0, end: progress),
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.linear,
                                builder: (BuildContext context, double value, Widget? child) {  
                                  final color= Color.lerp(const Color.fromARGB(255, 242, 31, 16), const Color.fromARGB(255, 69, 188, 9), value)!;
                                  return  CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 12.w,
                                  backgroundColor: trackColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    color,
                                  ),
                                );
                                },
                              
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 44.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  sessionState.isPlaying
                                      ? 'In Progress'
                                      : 'Paused',
                                  style: GoogleFonts.manrope(
                                    color: sessionState.isPlaying
                                        ? Colors.lightGreenAccent
                                        : Colors.redAccent,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: accentGlow.withOpacity(0.28),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: sessionNotifier.nextExercise,
                      icon: Icon(Icons.skip_next, size: 22.sp),
                      label: Text(
                        'Skip Rest',
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 155, 4, 4),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 28.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final currentExercise =
        sessionState.exercises[sessionState.currentExerciseIndex];
    final progress =
        (sessionState.currentExerciseIndex + 1) / sessionState.exercises.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _showExitDialog(context, sessionNotifier);
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => _showExitDialog(context, sessionNotifier),
          ),
          title: Text(
            '${bodyPart.name.toUpperCase()} WORKOUT',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 4.h),
                _buildProgressBar(progress, sessionState),
                SizedBox(height: 8.h),
                _buildExerciseName(currentExercise.name),
                SizedBox(height: 8.h),
                // Animation panel takes flexible space
                Expanded(
                  child: Center(
                    child: _buildAnimationPanel(currentExercise),
                  ),
                ),
                SizedBox(height: 8.h),
                _buildTimerPanel(sessionState),
                SizedBox(height: 8.h),
                _buildControlButtons(context, sessionState, sessionNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, WorkoutSessionState sessionState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: accentGlow.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: surfaceColor,
              valueColor: AlwaysStoppedAnimation<Color>(accentGlow),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercise ${sessionState.currentExerciseIndex + 1}/${sessionState.exercises.length}',
              style: GoogleFonts.manrope(
                color: Colors.grey[300],
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatTime(sessionState.totalTimeSpent),
              style: GoogleFonts.manrope(
                color: Colors.grey[300],
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExerciseMeta(WorkoutSessionState sessionState) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: surfaceColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: surfaceColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 4, 16, 86).withOpacity(0.25),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(
              Icons.fitness_center,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionState.bodyPart.name.toUpperCase(),
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  sessionState.isPlaying
                      ? 'Maintain tempo and form'
                      : 'Paused — tap play to resume',
                  style: GoogleFonts.manrope(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 99, 99).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: const Color.fromARGB(255, 255, 99, 99)),
            ),
            child: Text(
              sessionState.isPlaying ? 'LIVE' : 'PAUSED',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseName(String name) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
          color: Colors.white,
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildAnimationPanel(Exercise currentExercise) {
    final isLocalImage =
        currentExercise.animation.endsWith('.png') ||
        currentExercise.animation.endsWith('.jpg');
    final isNetworkGif =
        currentExercise.animation.startsWith('http') &&
        currentExercise.animation.endsWith('.gif');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: isNetworkGif
            ? CachedNetworkImage(
                imageUrl: currentExercise.animation,
                fit: BoxFit.contain,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(color: Colors.grey[600]),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 48.sp,
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        currentExercise.name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.grey[400],
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : isLocalImage
            ? Image.asset(
                currentExercise.animation,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.fitness_center,
                      size: 48.sp,
                      color: Colors.grey[600],
                    ),
                  );
                },
              )
            : Lottie.asset(
                currentExercise.animation,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 48.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          currentExercise.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: Colors.grey[400],
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTimerPanel(WorkoutSessionState sessionState) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: _buildTimer(sessionState)),
    );
  }

  Widget _buildTimer(WorkoutSessionState sessionState) {
    final minutes = sessionState.timeRemaining ~/ 60;
    final seconds = sessionState.timeRemaining % 60;
    final totalSeconds =
        sessionState.exercises[sessionState.currentExerciseIndex].duration;
    final progress = sessionState.timeRemaining / totalSeconds;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200.w,
          height: 200.h,
          child: TweenAnimationBuilder(
            
            curve: Curves.fastOutSlowIn,
            
            tween: Tween<double>(begin: 0, end: progress),
            duration: const Duration(milliseconds: 1000),
            builder: (BuildContext context, double value, Widget? child) {
              final color = Color.lerp(const Color.fromARGB(255, 242, 31, 16), const Color.fromARGB(255, 85, 229, 12), value)!; 
              return CircularProgressIndicator(
              value: value,
              strokeWidth: 12.w,
              backgroundColor: trackColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                color,
              ),
            );
             },
            
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 44.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: sessionState.isPlaying
                    ? Colors.lightGreenAccent.withOpacity(0.1)
                    : accentGlow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: sessionState.isPlaying
                      ? Colors.lightGreenAccent.withOpacity(0.3)
                      : accentGlow.withOpacity(0.3),
                ),
              ),
              child: Text(
                sessionState.isPlaying ? 'IN PROGRESS' : 'PAUSED',
                style: GoogleFonts.poppins(
                  color: sessionState.isPlaying
                      ? Colors.lightGreenAccent
                      : accentGlow,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    WorkoutSessionState sessionState,
    WorkoutSessionNotifier sessionNotifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircularButton(
            icon: Icons.skip_previous,
            onPressed: sessionState.currentExerciseIndex > 0
                ? sessionNotifier.previousExercise
                : null,
            size: 48,
          ),
          _buildCircularButton(
            icon: sessionState.isPlaying ? Icons.pause : Icons.play_arrow,
            onPressed: sessionState.isPlaying
                ? sessionNotifier.pauseTimer
                : sessionNotifier.startTimer,
            size: 64,
          ),
          _buildCircularButton(
            icon: Icons.skip_next,
            onPressed:
                sessionState.currentExerciseIndex <
                    sessionState.exercises.length - 1
                ? sessionNotifier.nextExercise
                : null,
            size: 48,
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback? onPressed,
    double size = 60,
    Color? color,
  }) {
    final isPlayButton = size > 60;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlayButton ? accentColor : (color ?? trackColor),
        boxShadow: onPressed != null
            ? [
                if (isPlayButton)
                  BoxShadow(
                    color: accentGlow.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: IconButton(
        icon: Icon(icon, size: size * 0.5),
        onPressed: onPressed,
        color: Colors.white,
        disabledColor: Colors.grey[600],
      ),
    );
  }

  Widget _buildCompletionScreen(
    BuildContext context,
    WorkoutSessionState sessionState,
  ) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://media.giphy.com/media/g9582DNuQppxC/giphy.gif',
                  width: 240.w,
                  height: 240.h,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => SizedBox(
                    width: 240.w,
                    height: 240.h,
                    child: Center(
                      child: Lottie.asset(
                        'assets/lottie/Fitness.json',
                        width: 240.w,
                        height: 240.h,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.celebration,
                    size: 100.sp,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                'Great job! You completed ${sessionState.exercises.length} exercises.',
                style: GoogleFonts.manrope(
                  color: Colors.grey[400],
                  fontSize: 15.sp,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),
              Builder(
                builder: (context) {
                  final availableWidth =
                      MediaQuery.of(context).size.width - (24.w * 2);
                  final statWidth = (availableWidth - 12.w) / 2;
                  return Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      _buildStatCard(
                        'Total Time',
                        _formatTime(sessionState.totalTimeSpent),
                        double.infinity,
                      ),
                      _buildStatCard(
                        'Exercises',
                        '${sessionState.exercises.length}',
                        double.infinity,
                      ),
                      _buildStatCard(
                        'Body Part',
                        sessionState.bodyPart.name.toUpperCase(),
                        double.infinity,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 155, 4, 4),
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    shadowColor: const Color.fromARGB(
                      255,
                      32,
                      10,
                      105,
                    ).withOpacity(0.4),
                  ),
                  child: Text(
                    'DONE',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, double width) {
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: surfaceColor),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(color: Colors.white70, fontSize: 14),
            ),
            Text(
              value,
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExitDialog(
    BuildContext context,
    WorkoutSessionNotifier sessionNotifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Exit Workout?',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Your progress will not be saved if you exit now.',
          style: GoogleFonts.manrope(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Continue',
              style: GoogleFonts.manrope(color: Colors.orangeAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              sessionNotifier.pauseTimer();
              sessionNotifier.soundService.stopBackgroundMusic();
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Exit',
              style: GoogleFonts.manrope(
                color: const Color.fromARGB(255, 255, 99, 99),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }
}
