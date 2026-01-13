import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final currentExercise = sessionState.exercises[sessionState.currentExerciseIndex];
    final progress = (sessionState.currentExerciseIndex + 1) / sessionState.exercises.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          children: [
           
            _buildProgressBar(progress, sessionState),
            const SizedBox(height: 20),
            
            Text(
              'Exercise ${sessionState.currentExerciseIndex + 1} of ${sessionState.exercises.length}',
              style: GoogleFonts.poppins(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            // Exercise Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                currentExercise.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            // Animation
            Expanded(
              child: Center(
                child: Lottie.asset(
                  currentExercise.animation,
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Timer
            _buildTimer(sessionState),
            const SizedBox(height: 30),
            // Control Buttons
            _buildControlButtons(context, sessionState, sessionNotifier),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, WorkoutSessionState sessionState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total time: ${_formatTime(sessionState.totalTimeSpent)}',
            style: GoogleFonts.poppins(
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
              progress > 0.3 ? Colors.greenAccent : Colors.redAccent,
            ),
          ),
        ),
        Column(
          children: [
            Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sessionState.isPlaying ? 'In Progress' : 'Paused',
              style: GoogleFonts.poppins(
                color: sessionState.isPlaying ? Colors.greenAccent : Colors.orange,
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
            color: Colors.greenAccent,
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
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 30),
                Text(
                  'Workout Complete!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Great job! You completed ${sessionState.exercises.length} exercises',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildStatCard('Total Time', _formatTime(sessionState.totalTimeSpent)),
                const SizedBox(height: 10),
                _buildStatCard('Exercises', '${sessionState.exercises.length}'),
                const SizedBox(height: 10),
                _buildStatCard('Body Part', sessionState.bodyPart.name.toUpperCase()),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
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
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
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
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: GoogleFonts.poppins(color: Colors.greenAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              sessionNotifier.pauseTimer();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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