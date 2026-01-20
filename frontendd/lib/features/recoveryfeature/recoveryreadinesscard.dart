import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/components/homeappbar.dart';

import 'package:frontendd/features/recoveryfeature/recoverystate.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Recoveryreadinesscard extends ConsumerStatefulWidget {
  const Recoveryreadinesscard({super.key});
  
  @override
  ConsumerState<Recoveryreadinesscard> createState() => _Recoveryreadinesscardstate();
}
class _Recoveryreadinesscardstate extends ConsumerState<Recoveryreadinesscard> {
  final _formkey=GlobalKey<FormState>();
  final _sleepHoursController = TextEditingController();
  final _sleepQualityController = TextEditingController();
  final _fatigueLevelController = TextEditingController();
  final _muscleSorenessController = TextEditingController();
  final _prevDayIntensityController = TextEditingController();
  final _workoutStreakController = TextEditingController();
  final _restingHRController = TextEditingController();
  bool isloading=false;
  double? overallscore;

  @override
  void dispose() {
    _sleepHoursController.dispose();
    _sleepQualityController.dispose();
    _fatigueLevelController.dispose();
    _muscleSorenessController.dispose();
    _prevDayIntensityController.dispose();
    _workoutStreakController.dispose();
    _restingHRController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: HomeAppBar(),
      body: overallscore==null? buildform() : buildresult(),
    );
  }

  Widget buildform(){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column (
            children: [
              TextFormField(
                controller: _sleepHoursController,
                decoration: InputDecoration(
                  labelText: 'Sleep Hours',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Sleep hours'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _sleepQualityController,
                decoration: InputDecoration(
                  labelText: 'Sleep Quality (1-5)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Sleep quality'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _fatigueLevelController,
                decoration: InputDecoration(
                  labelText: 'Fatigue Level (1-5)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Fatigue level'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _muscleSorenessController,
                decoration: InputDecoration(
                  labelText: 'Muscle Soreness (1-5)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Muscle soreness'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _prevDayIntensityController,
                decoration: InputDecoration(
                  labelText: 'Previous Day Intensity (0.0-1.0)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Previous day intensity'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _workoutStreakController,
                decoration: InputDecoration(
                  labelText: 'Workout Streak (days)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Workout streak'),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _restingHRController,
                decoration: InputDecoration(
                  labelText: 'Resting Heart Rate',
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumber(value, 'Resting heart rate'),
              ),
            
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: isloading ? null : _submitForm,
                child: isloading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text('Calculate Recovery Readiness Score'),
              ),
            ],
          ),
        ),
      ),

    );
  }
  Widget buildresult(){
    return Padding(padding: EdgeInsets.all(16.0),
      child: Text(
        'Your score is ${overallscore!.toString()}',
      ),
    );
  }
  Future<void> _submitForm() async {
    final form = _formkey.currentState;
    
    if (form == null || !form.validate()) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error',
          message: 'Please fill the form before submitting.',
          contentType: ContentType.failure,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() => isloading = true);

    try {
      debugPrint('Submitting recovery metrics');

      final userMetrics = {
        "sleep_hours": double.parse(_sleepHoursController.text),
        "sleep_quality": int.parse(_sleepQualityController.text),
        "fatigue_level": int.parse(_fatigueLevelController.text),
        "muscle_soreness": int.parse(_muscleSorenessController.text),
        "prev_day_intensity": double.parse(_prevDayIntensityController.text),
        "workout_streak": int.parse(_workoutStreakController.text),
        "resting_hr": int.parse(_restingHRController.text),
      };

      final result = await ref.read(recoveryReadinessProvider(userMetrics).future);

      setState(() {
        overallscore = result.overallscore;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Success',
              message: 'Recovery score: ${result.overallscore.toStringAsFixed(1)}',
              contentType: ContentType.success,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Error',
              message: 'Error: ${e.toString()}',
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isloading = false);
      }
    }
  }

  String? _validateNumber(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return double.tryParse(value.trim()) == null ? 'Enter a valid number' : null;
  }
}

