import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontendd/features/weeklyworkout/workout_session_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'exercisemodel.dart';
import 'workoutsessionprovider.dart';

class ExerciseExecutionPage extends ConsumerWidget {
  final List<Exercise> exercises;
  final BodyPart bodyPart;

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
      workoutSessionProvider((bodyPart: bodyPart, exercises: exercises)).notifier,
    );

    const backgroundColor = Color.fromARGB(255, 20, 6, 6);
    const surfaceColor = Color.fromARGB(255, 36, 12, 12);
    const trackColor = Color.fromARGB(255, 60, 20, 20);
    const accentColor = Color.fromARGB(255, 255, 99, 99);
    const accentGlow = Color.fromARGB(255, 220, 50, 50);
    final softAccent = Colors.orangeAccent;

    if (sessionState.isCompleted) {
      return _buildCompletionScreen(context, sessionState);
    }
    if (sessionState.isInCooldown == true) {
      final minutes = sessionState.cooldownTimeRemaining ~/ 60;
      final seconds = sessionState.cooldownTimeRemaining % 60;
      final progress = sessionState.cooldownTimeRemaining / 15;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 60, 15, 15),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => _showExitDialog(context, sessionNotifier),
          ),
          title: Text(
            '${bodyPart.name.toUpperCase()} WORKOUT',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                      SizedBox(height: 8.h),
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
                          border: Border.all(color: accentColor.withOpacity(0.15)),
                          boxShadow: [
                            BoxShadow(
                              color: accentGlow.withOpacity(0.12),
                              blurRadius: 30,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              'assets/lottie/relax.json',
                              width: 220.w,
                              height: 220.h,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: 20.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  height: 200.h,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 12.w,
                                    backgroundColor: trackColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      progress > 0.3 ? accentColor : softAccent,
                                    ),
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
                                      sessionState.isPlaying ? 'In Progress' : 'Paused',
                                      style: GoogleFonts.manrope(
                                        color: sessionState.isPlaying ? accentColor : softAccent,
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
                            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
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
      );
    }
    final currentExercise = sessionState.exercises[sessionState.currentExerciseIndex];
    final progress = (sessionState.currentExerciseIndex + 1) / sessionState.exercises.length;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 15, 15),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showExitDialog(context, sessionNotifier),
        ),
        title: Text(
          '${bodyPart.name.toUpperCase()} WORKOUT',
          style: GoogleFonts.manrope(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8.h),
              _buildProgressBar(progress, sessionState),
              SizedBox(height: 10.h),
              // _buildExerciseMeta(sessionState),
              // SizedBox(height: 14.h),
              _buildExerciseName(currentExercise.name),
              SizedBox(height: 15.h),
              _buildAnimationPanel(currentExercise),
              SizedBox(height: 15.h),
              _buildTimerPanel(sessionState),
              SizedBox(height: 15.h),
              _buildControlButtons(context, sessionState, sessionNotifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, WorkoutSessionState sessionState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: const Color.fromARGB(255, 60, 20, 20),
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 255, 99, 99)),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercise ${sessionState.currentExerciseIndex + 1}/${sessionState.exercises.length}',
              style: GoogleFonts.manrope(
                color: Colors.grey[300],
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatTime(sessionState.totalTimeSpent),
              style: GoogleFonts.manrope(
                color: Colors.grey[300],
                fontSize: 13.sp,
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
        color: const Color.fromARGB(255, 36, 12, 12),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color.fromARGB(60, 255, 99, 99)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 60, 20, 20),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.25),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(Icons.fitness_center, color: Colors.white, size: 20),
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
                  sessionState.isPlaying ? 'Maintain tempo and form' : 'Paused — tap play to resume',
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 12, 12),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color.fromARGB(50, 255, 99, 99)),
      ),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
          color: Colors.white,
          fontSize: 26.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildAnimationPanel(Exercise currentExercise) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 12, 12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromARGB(50, 255, 99, 99)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.1),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Lottie.asset(
            currentExercise.animation,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildTimerPanel(WorkoutSessionState sessionState) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 12, 12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color.fromARGB(80, 255, 99, 99)),
      ),
      child: Center(child: _buildTimer(sessionState)),
    );
  }

  Widget _buildTimer(WorkoutSessionState sessionState) {
    final minutes = sessionState.timeRemaining ~/ 60;
    final seconds = sessionState.timeRemaining % 60;
    final totalSeconds = sessionState.exercises[sessionState.currentExerciseIndex].duration;
    final progress = sessionState.timeRemaining / totalSeconds;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 12,
            backgroundColor: const Color.fromARGB(255, 60, 20, 20),
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.3 ? const Color.fromARGB(255, 255, 99, 99) : Colors.orangeAccent,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sessionState.isPlaying ? 'In Progress' : 'Paused',
              style: GoogleFonts.manrope(
                color: sessionState.isPlaying ? const Color.fromARGB(255, 255, 99, 99) : Colors.orangeAccent,
                fontSize: 14,
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
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 36, 12, 12),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color.fromARGB(60, 255, 99, 99)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 12),
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
            size: 56,
          ),
          _buildCircularButton(
            icon: sessionState.isPlaying ? Icons.pause : Icons.play_arrow,
            onPressed: sessionState.isPlaying
                ? sessionNotifier.pauseTimer
                : sessionNotifier.startTimer,
            size: 78,
            color: const Color.fromARGB(255, 255, 99, 99),
          ),
          _buildCircularButton(
            icon: Icons.skip_next,
            onPressed: sessionState.currentExerciseIndex < sessionState.exercises.length - 1
                ? sessionNotifier.nextExercise
                : null,
            size: 56,
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
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? const Color.fromARGB(255, 36, 12, 12),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: (color ?? Colors.redAccent).withOpacity(0.35),
                  blurRadius: 12,
                  spreadRadius: 2,
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

  Widget _buildCompletionScreen(BuildContext context, WorkoutSessionState sessionState) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 6, 6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/Fitness.json',
                width: 240.w,
                height: 240.h,
              ),
              SizedBox(height: 28.h),
              Text(
                'Workout Complete!',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
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
                  final availableWidth = MediaQuery.of(context).size.width - (24.w * 2);
                  final statWidth = (availableWidth - 12.w) / 2;
                  return Wrap(
                    spacing: 12.w,
                    runSpacing: 12.h,
                    children: [
                      _buildStatCard('Total Time', _formatTime(sessionState.totalTimeSpent), statWidth),
                      _buildStatCard('Exercises', '${sessionState.exercises.length}', statWidth),
                      _buildStatCard('Body Part', sessionState.bodyPart.name.toUpperCase(), statWidth),
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
                    shadowColor: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.4),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 36, 12, 12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(80, 255, 99, 99)),
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
              style: GoogleFonts.manrope(
                color: Colors.white70,
                fontSize: 14,
              ),
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

  void _showExitDialog(BuildContext context, WorkoutSessionNotifier sessionNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 36, 12, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Exit Workout?',
          style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.bold),
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
              if (context.mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Exit',
                style: GoogleFonts.manrope(color: const Color.fromARGB(255, 255, 99, 99)),
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