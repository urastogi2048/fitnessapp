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

    if (sessionState.isCompleted) {
      return _buildCompletionScreen(context, sessionState);
    }
    if(sessionState.isInCooldown==true){
      final minutes = sessionState.cooldownTimeRemaining ~/60;
      final seconds = sessionState.cooldownTimeRemaining %60;
      final progress= sessionState.cooldownTimeRemaining/15;
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 128, 5, 5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showExitDialog(context, sessionNotifier),
        ),
        title: Text(
          '${bodyPart.name.toUpperCase()} WORKOUT',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Text(
                  "Rest Time!",
                  style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 28.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Text(
                  "Take a deep breath and be ready!",
                  style: GoogleFonts.poppins(color: Colors.grey,fontWeight: FontWeight.bold, fontSize: 20.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Lottie.asset(
                'assets/lottie/relax.json',
                width: 250.w,
                height: 250.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
          SizedBox(
            width: 200.w,
            height: 200.h,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12.w,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.3 ? const Color.fromARGB(255, 220, 50, 50) : Colors.redAccent,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                sessionState.isPlaying ? 'In Progress' : 'Paused',
                style: GoogleFonts.oswald(
                  color: sessionState.isPlaying ? const Color.fromARGB(255, 220, 50, 50) : Colors.orange,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    sessionNotifier.nextExercise();
                  },
                  icon: Icon(Icons.skip_next, size: 24.sp),
                  label: Text(
                    "Skip Rest",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 155, 4, 4),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    elevation: 8,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    final currentExercise = sessionState.exercises[sessionState.currentExerciseIndex];
    final progress = (sessionState.currentExerciseIndex + 1) / sessionState.exercises.length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 1, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 128, 5, 5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => _showExitDialog(context, sessionNotifier),
        ),
        title: Text(
          '${bodyPart.name.toUpperCase()} WORKOUT',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            _buildProgressBar(progress, sessionState),
            SizedBox(height: 20.h),
            
            Text(
              'Exercise ${sessionState.currentExerciseIndex + 1} of ${sessionState.exercises.length}',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 10.h),
            // Exercise Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                currentExercise.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.h),
            // Animation
            Expanded(
              child: Center(
                child: Lottie.asset(
                  currentExercise.animation,
                  width: 300.w,
                  height: 300.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            _buildTimer(sessionState),
            SizedBox(height: 30.h),
            
            _buildControlButtons(context, sessionState, sessionNotifier),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, WorkoutSessionState sessionState) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 220, 50, 50)),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Total time: ${_formatTime(sessionState.totalTimeSpent)}',
            style: GoogleFonts.oswald(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
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
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(
              progress > 0.3 ? const Color.fromARGB(255, 48, 253, 17) : Colors.redAccent,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sessionState.isPlaying ? 'In Progress' : 'Paused',
              style: GoogleFonts.oswald(
                color: sessionState.isPlaying ? const Color.fromARGB(255, 220, 50, 50) : Colors.orange,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCircularButton(
            icon: Icons.skip_previous,
            onPressed: sessionState.currentExerciseIndex > 0
                ? sessionNotifier.previousExercise
                : null,
            size: 50,
          ),
          _buildCircularButton(
            icon: sessionState.isPlaying ? Icons.pause : Icons.play_arrow,
            onPressed: sessionState.isPlaying
                ? sessionNotifier.pauseTimer
                : sessionNotifier.startTimer,
            size: 70,
            color: const Color.fromARGB(255, 155, 4, 4),
          ),
          _buildCircularButton(
            icon: Icons.skip_next,
            onPressed: sessionState.currentExerciseIndex < sessionState.exercises.length - 1
                ? sessionNotifier.nextExercise
                : null,
            size: 50,
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
        color: color ?? Colors.grey[800],
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: (color ?? Colors.grey).withOpacity(0.5),
                  blurRadius: 10,
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/Fitness.json',
                  width: 250.w,
                  height: 250.h,
                ),
                SizedBox(height: 30.h),
                Text(
                  'Workout Complete!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Great job! You completed ${sessionState.exercises.length} exercises',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                _buildStatCard('Total Time', _formatTime(sessionState.totalTimeSpent)),
                SizedBox(height: 10.h),
                _buildStatCard('Exercises', '${sessionState.exercises.length}'),
                SizedBox(height: 10.h),
                _buildStatCard('Body Part', sessionState.bodyPart.name.toUpperCase()),
                SizedBox(height: 50.h),
                ElevatedButton(
                  onPressed: () {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 163, 68, 68),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color.fromARGB(255, 109, 1, 1).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context, WorkoutSessionNotifier sessionNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Exit Workout?',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        content: Text(
          'Your progress will not be saved if you exit now.',
          style: GoogleFonts.poppins(color: Colors.grey[400]),
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
              style: GoogleFonts.poppins(color: const Color.fromARGB(255, 220, 50, 50)),
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
              style: GoogleFonts.poppins(color: Colors.redAccent),
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