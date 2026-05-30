import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:frontendd/components/customappbar.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/auth/qprovider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/features/auth/qrepo.dart';
import 'package:frontendd/features/auth/qstate.dart';
import 'package:frontendd/core/onboardingstorage.dart';
import 'package:frontendd/features/home/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

class QuestionnairePage extends ConsumerWidget {
  const QuestionnairePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<Qstate>(qprovider, (prev, next) async {
      if (prev?.step != 5 && next.step == 6) {
        try {
          await QRepo().saveProfile(
            age: next.age ?? 18,
            gender: next.gender ?? "male",
            weight: next.weight ?? 70,
            height: next.height!,
            bodyType: next.bodyType!,
            goal: next.goal!,
          );
          await OnboardingStorage.markCompleted();

          await ref.read(authProvider.notifier).fetchUser();

          ref.invalidate(profileProvider);
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    });

    final qstate = ref.watch(qprovider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          // Prevent back navigation during questionnaire
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please complete the questionnaire to continue'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personal Questionnaire',
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
                  'Please answer the following questions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: Column(
                    children: [
                      if (qstate.errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 226, 46, 46).withOpacity(0.15),
                            border: Border.all(
                              color: const Color.fromARGB(255, 226, 46, 46),
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color.fromARGB(255, 226, 46, 46),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  qstate.errorMessage ?? '',
                                  style: TextStyle(
                                    color: const Color.fromARGB(255, 226, 46, 46),
                                    fontFamily: GoogleFonts.poppins().fontFamily,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: switch (qstate.step) {
                          0 => AgeQuestion(qstate: qstate, ref: ref),
                          1 => GenderQuestion(qstate: qstate, ref: ref),
                          2 => WeightQuestion(qstate: qstate, ref: ref),
                          3 => HeightQuestion(qstate: qstate, ref: ref),
                          4 => BodyTypeQuestion(qstate: qstate, ref: ref),
                          _ => GoalQuestion(
                            qstate: qstate,
                            ref: ref,
                            context: context,
                          ),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget AgeQuestion({required Qstate qstate, required WidgetRef ref}) {
  final age = qstate.age ?? 18;

  return Container(
    color: const Color.fromARGB(255, 27, 27, 27),
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
                minValue: 13,
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
                  ref.read(qprovider.notifier).clearError();
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // NEXT / PREVIOUS BUTTONS
        Row(
          children: [
            if (qstate.step > 0) ...[
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
            ],

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 226, 46, 46),
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
    final bool isSelected = selected?.toLowerCase() == label.toLowerCase();

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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        onPressed: () {
          ref.read(qprovider.notifier).setGender(label.toLowerCase());
          ref.read(qprovider.notifier).clearError();
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
    color: const Color.fromARGB(255, 27, 27, 27),
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
                  backgroundColor: const Color.fromARGB(255, 226, 46, 46),
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

Widget WeightQuestion({required Qstate qstate, required WidgetRef ref}) {
  final weight = qstate.weight ?? 70;
  return Container(
    color: const Color.fromARGB(255, 27, 27, 27),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What is your weight (kg)?',
          style: TextStyle(
            fontSize: 18,
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(
            '$weight',
            key: ValueKey(weight),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: Colors.red,
            ),
          ),
        ),
        //SizedBox(height: 5),
        Text(
          'kg',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade500,
            fontFamily: GoogleFonts.oswald().fontFamily,
          ),
        ),
        SizedBox(height: 20),
        NumberPicker(
          minValue: 25,
          maxValue: 200,
          value: weight.toInt(),
          onChanged: (value) {
            ref.read(qprovider.notifier).setWeight(value.toDouble());
            ref.read(qprovider.notifier).clearError();
          },
          axis: Axis.horizontal,
          selectedTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
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
                  backgroundColor: const Color.fromARGB(255, 226, 46, 46),
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

Widget HeightQuestion({required Qstate qstate, required WidgetRef ref}) {
  final height = qstate.height ?? 170;

  return Container(
    color: const Color.fromARGB(255, 27, 27, 27),
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What is your height (cm)?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Text(
            '$height',
            key: ValueKey(height),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ),
        Text(
          "cm",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade500,
            fontFamily: GoogleFonts.oswald().fontFamily,
          ),
        ),
        SizedBox(height: 20),
        NumberPicker(
          minValue: 100,
          maxValue: 250,
          value: height.toInt(),
          onChanged: (value) {
            ref.read(qprovider.notifier).setHeight(value.toDouble());
            ref.read(qprovider.notifier).clearError();
          },
          axis: Axis.horizontal,
          selectedTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
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
                  backgroundColor: const Color.fromARGB(255, 226, 46, 46),
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

Widget BodyTypeQuestion({required Qstate qstate, required WidgetRef ref}) {
  final selected = qstate.bodyType;

  Widget option(String label) {
    final bool isSelected = selected?.toLowerCase() == label.toLowerCase();

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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        onPressed: () {
          ref.read(qprovider.notifier).setBodyType(label.toLowerCase());
          ref.read(qprovider.notifier).clearError();
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
    color: const Color.fromARGB(255, 27, 27, 27),
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

        option("Slim"),
        const SizedBox(height: 12),
        option("Athletic"),
        const SizedBox(height: 12),
        option("Heavy"),

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
                  backgroundColor: const Color.fromARGB(255, 226, 46, 46),
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

Widget GoalQuestion({
  required Qstate qstate,
  required WidgetRef ref,
  required BuildContext context,
}) {
  final selected = qstate.goal;

  Widget option(String label) {
    final bool isSelected = selected?.toLowerCase() == label.toLowerCase();

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
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        onPressed: () {
          ref.read(qprovider.notifier).setGoal(label.toLowerCase());
          ref.read(qprovider.notifier).clearError();
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
    color: const Color.fromARGB(255, 27, 27, 27),
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
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 226, 46, 46),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  final currentQ = ref.read(qprovider);

                  if (currentQ.goal == null) {
                    ref.read(qprovider.notifier).setError('Please select your fitness goal');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select your fitness goal',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
                      ),
                    );
                    return;
                  }

                  try {
                    await QRepo().saveProfile(
                      age: currentQ.age ?? 18,
                      gender: currentQ.gender ?? 'male',
                      weight: currentQ.weight ?? 70,
                      height: currentQ.height!,
                      bodyType: currentQ.bodyType!,
                      goal: currentQ.goal!,
                    );

                    await OnboardingStorage.markCompleted();
                    await ref.read(authProvider.notifier).fetchUser();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: Please complete all fields',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
                      ),
                    );
                  }
                },
                child: Text(
                  'Finish',
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
