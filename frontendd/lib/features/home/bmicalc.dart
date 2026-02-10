import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:numberpicker/numberpicker.dart';

class BMICalculator extends StatefulWidget {
  const BMICalculator({super.key});

  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  final TextEditingController heightController = TextEditingController(
    text: '170',
  );
  final TextEditingController weightController = TextEditingController(
    text: '70',
  );
  //final double bmi;
  bool ispressed = false;
  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  'BMI Calculator',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  'Calculate your Body Mass Index',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 20.0),

                // Height Picker
                Text(
                  'Height (cm)',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 0, 230),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                const SizedBox(height: 12.0),
                NumberPicker(
                  minValue: 50,
                  maxValue: 250,
                  value: heightController.text.isEmpty
                      ? 170
                      : int.parse(heightController.text),
                  itemHeight: 60,
                  axis: Axis.horizontal,
                  selectedTextStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  onChanged: (value) {
                    setState(() {
                      heightController.text = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 20.0),

                // Weight Picker
                Text(
                  'Weight (kg)',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 102, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                const SizedBox(height: 12.0),
                NumberPicker(
                  minValue: 20,
                  maxValue: 200,
                  value: weightController.text.isEmpty
                      ? 70
                      : int.parse(weightController.text),
                  itemHeight: 60,
                  axis: Axis.horizontal,
                  selectedTextStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  onChanged: (value) {
                    setState(() {
                      weightController.text = value.toString();
                    });
                  },
                ),
                const SizedBox(height: 30.0),

                // Calculate Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ispressed = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //  const Icon(FontAwesomeIcons.calculator, size: 20),
                        // const SizedBox(width: 12),
                        Text(
                          'CALCULATE BMI',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),

                // Result Display
                if (ispressed &&
                    heightController.text.isNotEmpty &&
                    weightController.text.isNotEmpty)
                  _buildResultCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final double bmiValue =
        double.parse(weightController.text) /
        ((double.parse(heightController.text) / 100) *
            (double.parse(heightController.text) / 100));

    Color bmiColor;
    String bmiCategory;
    IconData bmiIcon;

    if (bmiValue < 18.5) {
      bmiColor = Colors.blue;
      bmiCategory = 'Underweight';
      bmiIcon = FontAwesomeIcons.faceGrinBeamSweat;
    } else if (bmiValue < 25) {
      bmiColor = Colors.green;
      bmiCategory = 'Normal Weight';
      bmiIcon = FontAwesomeIcons.faceSmileBeam;
    } else if (bmiValue < 30) {
      bmiColor = Colors.orange;
      bmiCategory = 'Overweight';
      bmiIcon = FontAwesomeIcons.faceMeh;
    } else {
      bmiColor = Colors.red;
      bmiCategory = 'Obese';
      bmiIcon = FontAwesomeIcons.faceFrown;
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 8, 13, 30),
            const Color.fromARGB(255, 8, 13, 30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bmiColor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bmiColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(bmiIcon, size: 40, color: bmiColor),
          ),
          const SizedBox(height: 16),

          // BMI Label
          Text(
            'Your BMI',
            style: GoogleFonts.manrope(
              color: Colors.grey[400],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),

          // BMI Value
          Text(
            bmiValue.toStringAsFixed(1),
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),

          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: bmiColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: bmiColor.withOpacity(0.4)),
            ),
            child: Text(
              bmiCategory.toUpperCase(),
              style: GoogleFonts.manrope(
                color: bmiColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // BMI Categories Reference
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 30, 60),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI Categories',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildCategoryRow(Colors.blue, 'Underweight', '< 18.5'),
                _buildCategoryRow(Colors.green, 'Normal', '18.5 - 24.9'),
                _buildCategoryRow(Colors.orange, 'Overweight', '25 - 29.9'),
                _buildCategoryRow(Colors.red, 'Obese', '≥ 30'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(Color color, String category, String range) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category,
              style: GoogleFonts.manrope(
                color: Colors.grey[300],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            range,
            style: GoogleFonts.manrope(
              color: Colors.grey[400],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
