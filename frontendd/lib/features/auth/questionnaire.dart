import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontendd/components/customappbar.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/qprovider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/qrepo.dart';
import 'package:frontendd/features/auth/qstate.dart';
import 'package:frontendd/core/onboardingstorage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';
class QuestionnairePage extends ConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<Qstate>(qprovider, (prev, next) async {
      // ✅ LAST STEP IS 5, NOT 6
      if (prev?.step != 5 && next.step == 6) {
        try {
          await QRepo().saveProfile(
            age: next.age!,
            gender: next.gender!,
            weight: next.weight!,
            height: next.height!,
            bodyType: next.bodyType!,
            goal: next.goal!,
          );
          await OnboardingStorage.markCompleted();
          // 🔥 THIS IS WHAT UNBLOCKS AUTHGATE
          await ref
              .read(authProvider.notifier)
              .fetchUser();

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    });

    final qstate = ref.watch(qprovider);

    return Scaffold(
      appBar: CustomAppBar(title: "Questionnaire"),
      body: switch (qstate.step) {
        0 => AgeQuestion(qstate: qstate, ref: ref),
        1 => GenderQuestion(qstate: qstate, ref: ref),
        2 => WeightQuestion(qstate: qstate, ref: ref),
        3 => HeightQuestion(qstate: qstate, ref: ref),
        4 => BodyTypeQuestion(qstate: qstate, ref: ref),
        _ => GoalQuestion(qstate: qstate, ref: ref, context: context),
      },
    );
  }
}

Widget AgeQuestion({required Qstate qstate, required WidgetRef ref}) {
  final age = qstate.age ?? 18;

  return Container(
    color: const Color.fromARGB(255, 31, 7, 7),
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What is your age?',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),

        SizedBox(height: 16.h),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(
            "$age",
            key: ValueKey(age),
            style: TextStyle(
              fontSize: 48,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 226, 46, 46),
            ),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "years",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: GoogleFonts.oswald().fontFamily,
          ),
        ),

        const SizedBox(height: 32),

        SizedBox(
          height: 120,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
             
             
              
              NumberPicker(
  value: age,
  minValue: 10,
  maxValue: 100,
  itemHeight: 60,
  axis: Axis.horizontal,
  selectedTextStyle: TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 226, 46, 46),
    fontFamily: GoogleFonts.poppins().fontFamily,
  ),
  textStyle: TextStyle(
    fontSize: 18,
    color: Colors.grey,
    fontFamily: GoogleFonts.poppins().fontFamily,
  ),
  onChanged: (value) {
    ref.read(qprovider.notifier).setAge(value);
  },
),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // 🔥 NEXT / PREVIOUS BUTTONS
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444)),
                  foregroundColor: const Color.fromARGB(255, 98, 98, 98),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).previousStep();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 226, 46, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).nextStep();
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget GenderQuestion({required Qstate qstate, required WidgetRef ref}) {
  final selected = qstate.gender;

  Widget option(String label) {
    final bool isSelected =
        selected?.toLowerCase() == label.toLowerCase();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected
                ? const Color.fromARGB(255, 226, 46, 46)
                : const Color.fromARGB(255, 249, 171, 171),
          ),
          foregroundColor: MaterialStateProperty.all(
            isSelected ? Colors.white : Colors.black,
          ),
          elevation: MaterialStateProperty.all(isSelected ? 6 : 0),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        onPressed: () {
          ref
              .read(qprovider.notifier)
              .setGender(label.toLowerCase());
        },
        child: Text(
          label,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    color: const Color.fromARGB(255, 31, 7, 7),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'What is your gender?',
          style: TextStyle(
            fontSize: 18,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        option("Male"),
        const SizedBox(height: 12),
        option("Female"),
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444)),
                  foregroundColor: const Color.fromARGB(255, 194, 194, 194),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).previousStep();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 226, 46, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).nextStep();
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget WeightQuestion({required Qstate qstate, required WidgetRef ref}) {
  final weight = qstate.weight ?? 70;
  return Container(
    color:const Color.fromARGB(255, 31, 7, 7),
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [
        Text('What is your weight (kg)?', style: TextStyle(fontSize: 18, fontFamily: GoogleFonts.poppins().fontFamily, fontWeight: FontWeight.w500, color: Colors.white),),
        SizedBox(height: 20),
        AnimatedSwitcher(duration: Duration(milliseconds: 150),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Text('$weight', key: ValueKey(weight), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily, color: Colors.red),)
        ),
        //SizedBox(height: 5),
        Text('kg', style: TextStyle(fontSize: 16,color: Colors.grey.shade500, fontFamily: GoogleFonts.oswald().fontFamily),),
        SizedBox(height: 20),
        NumberPicker(minValue: 25, maxValue: 200, value: weight.toInt(), onChanged:(value) {
          ref.read(qprovider.notifier).setWeight(value.toDouble());
        }, axis: Axis.horizontal,
        selectedTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: GoogleFonts.poppins().fontFamily),
        textStyle: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        SizedBox(height: 40),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444)),
                  foregroundColor: const Color.fromARGB(255, 194, 194, 194),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).previousStep();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 226, 46, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).nextStep();
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        )
    
      ],
    ),
  );
}
Widget HeightQuestion({required Qstate qstate, required WidgetRef ref}) {
  final height =qstate.height ?? 170;
  
  return Container(
    color: const Color.fromARGB(255, 31, 7, 7),
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('What is your height (cm)?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: GoogleFonts.poppins().fontFamily, color: Colors.white),),
        SizedBox(height: 20),
        AnimatedSwitcher(duration: Duration(milliseconds: 150),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Text('$height', key: ValueKey(height), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: GoogleFonts.poppins().fontFamily ,) 
          
        ),),
        Text("cm", style: TextStyle(fontSize: 16,color: Colors.grey.shade500, fontFamily: GoogleFonts.oswald().fontFamily),),
        SizedBox(height: 20),
        NumberPicker(minValue: 100, maxValue: 250, value: height.toInt(), onChanged: (value) {
          ref.read(qprovider.notifier).setHeight(value.toDouble());
        }, axis: Axis.horizontal, 
        selectedTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red, fontFamily: GoogleFonts.poppins().fontFamily),
        textStyle: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        SizedBox(height: 20),
       Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444)),
                  foregroundColor: const Color.fromARGB(255, 194, 194, 194),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).previousStep();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 226, 46, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).nextStep();
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        )
    
      ],
    ),
  );
}
Widget BodyTypeQuestion({required Qstate qstate, required WidgetRef ref}) {
  final selected = qstate.bodyType;

  Widget option(String label) {
    final bool isSelected =
        selected?.toLowerCase() == label.toLowerCase();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected
                ? const Color.fromARGB(255, 226, 46, 46)
                : const Color.fromARGB(255, 249, 171, 171),
          ),
          foregroundColor: MaterialStateProperty.all(
            isSelected ? Colors.white : Colors.black,
          ),
          elevation: MaterialStateProperty.all(isSelected ? 6 : 0),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        onPressed: () {
          ref
              .read(qprovider.notifier)
              .setBodyType(label.toLowerCase());
        },
        child: Text(
          label,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    color: const Color.fromARGB(255, 31, 7, 7),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What is your body type?',
          style: TextStyle(
            fontSize: 18,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        option("Ectomorph"),
        const SizedBox(height: 12),
        option("Mesomorph"),
        const SizedBox(height: 12),
        option("Endomorph"),

        const SizedBox(height: 40),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444)),
                  foregroundColor: const Color.fromARGB(255, 194, 194, 194),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).previousStep();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 226, 46, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).nextStep();
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget GoalQuestion({required Qstate qstate, required WidgetRef ref, required BuildContext context}) {
  final selected = qstate.goal;

  Widget option(String label) {
    final bool isSelected =
        selected?.toLowerCase() == label.toLowerCase();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            isSelected
                ? const Color.fromARGB(255, 226, 46, 46)
                : const Color.fromARGB(255, 249, 171, 171),
          ),
          foregroundColor: MaterialStateProperty.all(
            isSelected ? Colors.white : Colors.black,
          ),
          elevation: MaterialStateProperty.all(isSelected ? 6 : 0),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        onPressed: () {
          ref
              .read(qprovider.notifier)
              .setGoal(label.toLowerCase());
        },
        child: Text(
          label,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    color: const Color.fromARGB(255, 31, 7, 7),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What is your fitness goal?',
          style: TextStyle(
            fontSize: 18,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),

        option("Lose Weight"),
        const SizedBox(height: 12),
        option("Build Muscle"),
        const SizedBox(height: 12),
        option("Maintain Fitness"),

        const SizedBox(height: 40),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF444444)),
                  foregroundColor: const Color.fromARGB(255, 194, 194, 194),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  ref.read(qprovider.notifier).previousStep();
                },
                child: Text(
                  'Previous',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: // Inside GoalQuestion widget
ElevatedButton(
  onPressed: () async {
    // 1. Manually trigger the save
    try {
      final currentQ = ref.read(qprovider);
      await QRepo().saveProfile(
        age: currentQ.age!,
        gender: currentQ.gender!,
        weight: currentQ.weight!,
        height: currentQ.height!,
        bodyType: currentQ.bodyType!,
        goal: currentQ.goal!, // Ensure the goal is set before clicking
      );

      // 2. Mark locally
      await OnboardingStorage.markCompleted();

      // 3. Refresh Auth State - This is what makes HomeScreen appear
      await ref.read(authProvider.notifier).fetchUser();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving: $e"))
      );
    }
  },
  child: const Text("Finish"),
)
            ),
          ],
        ),
      ],
    ),
  );
}
