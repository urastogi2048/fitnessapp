import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendd/components/homeappbar.dart';
import 'package:frontendd/features/home/streakservice.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:frontendd/features/recoveryfeature/recoverystate.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_wheel_selector/scroll_wheel_selector.dart';

class Recoveryreadinesscard extends ConsumerStatefulWidget {
  const Recoveryreadinesscard({super.key});

  @override
  ConsumerState<Recoveryreadinesscard> createState() =>
      _Recoveryreadinesscardstate();
}

class _Recoveryreadinesscardstate extends ConsumerState<Recoveryreadinesscard> {
  final _formkey = GlobalKey<FormState>();
  final _sleepHoursController = TextEditingController();
  final _sleepQualityController = TextEditingController();
  final _fatigueLevelController = TextEditingController();
  final _muscleSorenessController = TextEditingController(text: '3');
  final _prevDayIntensityController = TextEditingController();
  final _workoutStreakController = TextEditingController();
  final _restingHRController = TextEditingController();
  double _sleepHoursValue = 5.0;
  double previousDayIntensityValue = 0.5;
  int muscleSorenessValue = 3;
  int restingHRValue = 60;
  bool isloading = false;
  //int streak=0 ;
  double? overallscore;

  // Add these for the quality selector
  final List<int> _qualityValues = [1, 2, 3, 4, 5];
  int _sleepQualityValue = 3;
  final List<int> _fatigueValues = [1, 2, 3, 4, 5];
  int _fatigueLevelValue = 3;
  String _sorenessLabel(int value) {
    if (value <= 2) return 'Low';
    if (value == 3) return 'Moderate';
    return 'High';
  }

  Color _sorenessColor(int value) {
    if (value <= 2) return Colors.greenAccent;
    if (value == 3) return Colors.orangeAccent;
    return Colors.redAccent;
  }

  @override
  void initState() {
    super.initState();
    _sleepHoursController.text = _sleepHoursValue.toInt().toString();
    _sleepQualityController.text = _sleepQualityValue.toString();
    _fatigueLevelController.text = _fatigueLevelValue.toString();
    _muscleSorenessController.text = muscleSorenessValue.toString();
    _prevDayIntensityController.text = previousDayIntensityValue.toString();
    _workoutStreakController.text = '0';
    _restingHRController.text = '60';
  }

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: overallscore == null ? buildform() : buildresult(),
    );
  }

  Widget buildform() {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
            ),
            SizedBox(height: 12.0),
            Text(
              'Daily Check-In',
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontFamily: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                ).fontFamily,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Full body and mind analysis',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                ).fontFamily,
              ),
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    
                    Card(
                      color: const Color.fromARGB(255, 7, 26, 41),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'SLEEP HYGIENE',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.purpleAccent,
                                    fontFamily: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                    ).fontFamily,
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Icon(
                                    FontAwesomeIcons.cloudMoon,
                                    size: 40,
                                    color: const Color.fromARGB(148, 223, 64, 251),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Hours slept',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,

                                    fontFamily: GoogleFonts.manrope(
                                      //fontWeight: FontWeight.bold,
                                    ).fontFamily,
                                  ),
                                ),
                                Text(
                                  _sleepHoursValue.toStringAsFixed(0) + 'h',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                    ).fontFamily,
                                  ),
                                ),
                              ],
                            ),
                            SfSliderTheme(
                              data: SfSliderThemeData(
                                activeTrackHeight: 6,
                                activeLabelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: GoogleFonts.oswald().fontFamily,
                                ),
                                inactiveTrackHeight: 6,
                                inactiveLabelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: GoogleFonts.oswald().fontFamily,
                                ),

                                thumbRadius: 10,
                                overlayRadius: 18,
                                tooltipBackgroundColor: const Color.fromARGB(
                                  255,
                                  13,
                                  9,
                                  33,
                                ),

                                tooltipTextStyle: const TextStyle(
                                  color: Color.fromARGB(255, 111, 111, 111),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              child: SfSlider(
                                min: 2.0,
                                max: 9.0,
                                value: _sleepHoursValue,
                                interval: 1,
                                stepSize: 1,
                                showTicks: true,
                                showLabels: true,
                                enableTooltip: true,
                                onChanged: (value) {
                                  setState(() {
                                    _sleepHoursValue = value;
                                    _sleepHoursController.text = value
                                        .toInt()
                                        .toString();
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 0,
                              child: TextFormField(
                                controller: _sleepHoursController,
                                decoration: InputDecoration(
                                  labelText: 'Sleep Hours',
                                ),
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                enabled: false,
                              ),
                            ),

                            SizedBox(height: 40),
                            Text(
                              'Quality Rating',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                //fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Container(
                              height: 56,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 10, 6, 37),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: _qualityValues.map((value) {
                                  final isSelected =
                                      value == _sleepQualityValue;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _sleepQualityValue = value;
                                          _sleepQualityController.text =
                                              _sleepQualityValue.toString();
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.deepPurple
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 0,
                              child: TextFormField(
                                controller: _sleepQualityController,
                                decoration: InputDecoration(
                                  labelText: 'Sleep Quality (1-5)',
                                ),
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Card(
                      color: const Color.fromARGB(255, 7, 26, 41),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                Text(
                                  'BODY STATUS',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.orange,
                                    fontFamily: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                    ).fontFamily,
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.5,
                                  child: Icon(
                                    FontAwesomeIcons.personRunning,
                                    size: 40,
                                    color: const Color.fromARGB(148, 251, 153, 64),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Fatigue Level',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                //fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 56,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 10, 6, 37),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: _fatigueValues.map((value) {
                                  final isSelected =
                                      value == _fatigueLevelValue;
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _fatigueLevelValue = value;
                                          _fatigueLevelController.text =
                                              _fatigueLevelValue.toString();
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (() {
                                            if (isSelected) {
                                              if (value == 1) {
                                                return const Color.fromARGB(
                                                  172,
                                                  111,
                                                  255,
                                                  1,
                                                );
                                              } else if (value == 2) {
                                                return const Color.fromARGB(
                                                  255,
                                                  142,
                                                  203,
                                                  20,
                                                );
                                              } else if (value == 3) {
                                                return const Color.fromARGB(
                                                  255,
                                                  148,
                                                  153,
                                                  0,
                                                );
                                              } else if (value == 4) {
                                                return const Color.fromRGBO(
                                                  254,
                                                  159,
                                                  35,
                                                  0.735,
                                                );
                                              } else if (value == 5) {
                                                return const Color.fromARGB(
                                                  166,
                                                  255,
                                                  82,
                                                  82,
                                                );
                                              }
                                            }
                                            return Colors.transparent;
                                          }()),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.grey.shade500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Title row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Muscle Soreness',
                                      style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        //fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.local_fire_department,
                                      color: _sorenessColor(
                                        muscleSorenessValue,
                                      ),
                                      size: 18,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                /// Interactive slider with progress bar styling
                                TweenAnimationBuilder<double>(
                                  tween: Tween(
                                    begin: 0,
                                    end: muscleSorenessValue / 5,
                                  ),
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  builder: (context, animatedValue, child) {
                                    return SfSliderTheme(
                                      data: SfSliderThemeData(
                                        activeTrackHeight: 6,
                                        inactiveTrackHeight: 6,
                                        activeTrackColor: _sorenessColor(
                                          muscleSorenessValue,
                                        ),
                                        inactiveTrackColor:
                                            Colors.grey.shade800,
                                        thumbColor: _sorenessColor(
                                          muscleSorenessValue,
                                        ),
                                        thumbRadius: 8,
                                        overlayRadius: 16,
                                        tooltipBackgroundColor: _sorenessColor(
                                          muscleSorenessValue,
                                        ),
                                        tooltipTextStyle: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: SfSlider(
                                        min: 1.0,
                                        max: 5.0,
                                        interval: 1,
                                        stepSize: 1,
                                        value: muscleSorenessValue.toDouble(),
                                        showTicks: false,
                                        showLabels: false,
                                        enableTooltip: true,
                                        onChanged: (value) {
                                          setState(() {
                                            muscleSorenessValue = value.toInt();
                                            _muscleSorenessController.text =
                                                muscleSorenessValue.toString();
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 6),

                                /// Status text
                                Text(
                                  '${_sorenessLabel(muscleSorenessValue)} '
                                  '(${muscleSorenessValue}/5)',
                                  style: GoogleFonts.manrope(
                                    color: _sorenessColor(muscleSorenessValue),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                /// Hidden Form field (keeps validation + submit working)
                                SizedBox(
                                  height: 0,
                                  child: TextFormField(
                                    controller: _muscleSorenessController,
                                    enabled: false,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: 0,
                              child: TextFormField(
                                controller: _fatigueLevelController,
                                decoration: InputDecoration(
                                  labelText: 'Fatigue Level (1-5)',
                                ),
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Card(
                      color: const Color.fromARGB(255, 6, 25, 41),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RESTING HEART RATE',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.redAccent,
                                fontFamily: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                ).fontFamily,
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.heartPulse,
                                  color: Colors.redAccent,
                                  size: 60,
                                ),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${restingHRValue}',
                                            style: TextStyle(
                                              fontSize: 35,
                                              color: const Color.fromARGB(
                                                255,
                                                154,
                                                154,
                                                154,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontFamily: GoogleFonts.manrope()
                                                  .fontFamily,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'bpm',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey,
                                              fontFamily: GoogleFonts.manrope()
                                                  .fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      SfSliderTheme(
                                        data: SfSliderThemeData(
                                          activeTrackHeight: 6,
                                          inactiveTrackHeight: 6,
                                          activeTrackColor:
                                              const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255,
                                              ),
                                          inactiveTrackColor:
                                              Colors.grey.shade800,
                                          thumbColor: const Color.fromARGB(
                                            255,
                                            208,
                                            208,
                                            208,
                                          ),
                                          thumbRadius: 8,
                                          overlayRadius: 16,
                                          tooltipBackgroundColor:
                                              const Color.fromARGB(
                                                255,
                                                148,
                                                148,
                                                148,
                                              ),
                                          tooltipTextStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        child: SfSlider(
                                          min: 40.0,
                                          max: 100.0,
                                          interval: 10,
                                          stepSize: 1,
                                          value: restingHRValue.toDouble(),
                                          showTicks: true,
                                          showLabels: false,
                                          enableTooltip: true,
                                          onChanged: (value) {
                                            setState(() {
                                              restingHRValue = value.toInt();
                                              _restingHRController.text =
                                                  restingHRValue.toString();
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                //SizedBox(width: 15.0),
                              ],
                            ),
                            SizedBox(
                              height: 0,
                              child: TextFormField(
                                controller: _prevDayIntensityController,
                                decoration: InputDecoration(
                                  labelText: 'Previous Day Intensity (0.0-1.0)',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _validateNumber(
                                  value,
                                  'Previous day intensity',
                                ),
                                readOnly: true,
                                enabled: false,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(
                              height: 0,
                              child: TextFormField(
                                controller: _workoutStreakController,
                                decoration: InputDecoration(
                                  labelText: 'Workout Streak (days)',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    _validateNumber(value, 'Workout streak'),
                                readOnly: true,
                                enabled: false,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            SizedBox(
                              height: 0,
                              child: TextFormField(
                                controller: _restingHRController,
                                decoration: InputDecoration(
                                  labelText: 'Resting Heart Rate',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _validateNumber(
                                  value,
                                  'Resting heart rate',
                                ),
                                readOnly: true,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: isloading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: isloading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Color.fromARGB(255, 242, 239, 239),
                                ),
                              )
                            : Text(
                                'CALCULATE SCORE',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
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
          ],
        ),
      ),
    );
  }

  Widget buildresult() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
          
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

      final result = await ref.read(
        recoveryReadinessProvider(userMetrics).future,
      );

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
              message:
                  'Recovery score: ${result.overallscore.toStringAsFixed(1)}',
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
    return double.tryParse(value.trim()) == null
        ? 'Enter a valid number'
        : null;
  }
}
