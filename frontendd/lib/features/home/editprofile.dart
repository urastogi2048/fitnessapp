import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendd/features/auth/qprovider.dart';
import 'package:frontendd/features/auth/qstate.dart';
import 'package:frontendd/features/home/profile.dart';
import 'package:frontendd/features/auth/qrepo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numberpicker/numberpicker.dart';

class Editprofile extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  const Editprofile({super.key, required this.userProfile});
  @override
  ConsumerState<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends ConsumerState<Editprofile> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(qprovider.notifier);
      notifier.setAge(widget.userProfile.age ?? 18);
      notifier.setGender(widget.userProfile.gender?.toLowerCase() ?? 'male');
      notifier.setWeight(widget.userProfile.weight?.toDouble() ?? 70.0);
      notifier.setHeight(widget.userProfile.height?.toDouble() ?? 170.0);
      notifier.setBodyType(
        widget.userProfile.bodyType?.toLowerCase() ?? 'mesomorph',
      );
      notifier.setGoal(
        widget.userProfile.goal?.toLowerCase() ?? 'maintain fitness',
      );
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final state = ref.read(qprovider);
      await QRepo().updateProfile(
        age: state.age!,
        gender: state.gender!,
        weight: state.weight!,
        height: state.height!,
        bodyType: state.bodyType!,
        goal: state.goal!,
      );
      ref.invalidate(profileProvider);
      if (mounted) {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Success!',
            message: 'Your profile has been successfully updated.',
            contentType: ContentType.success,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Wait a moment before popping to show the snackbar
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    } catch (e) {
      if (mounted) {
        final snackBar = SnackBar(
          content: AwesomeSnackbarContent(
            title: 'Error',
            message: e.toString(),
            contentType: ContentType.failure,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildAgeSection(Qstate qstate) {
    final age = qstate.age ?? 18;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERSONAL INFO',
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
                FontAwesomeIcons.user,
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
              'Age',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            Text(
              '$age years',
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
        SizedBox(height: 12),
        NumberPicker(
          value: age,
          minValue: 10,
          maxValue: 100,
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
            ref.read(qprovider.notifier).setAge(value);
          },
        ),
      ],
    );
  }

  Widget _buildGenderSection(Qstate qstate) {
    final selected = qstate.gender;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 10, 6, 37),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: ['Male', 'Female'].map((gender) {
              final isSelected =
                  selected?.toLowerCase() == gender.toLowerCase();
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(qprovider.notifier)
                        .setGender(gender.toLowerCase());
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      gender,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey.shade500,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightSection(Qstate qstate) {
    final weight = qstate.weight ?? 70;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'BODY METRICS',
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
                FontAwesomeIcons.weightScale,
                size: 40,
                color: const Color.fromARGB(148, 251, 153, 64),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Weight',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            Text(
              '${weight.toInt()} kg',
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
        SizedBox(height: 12),
        NumberPicker(
          value: weight.toInt(),
          minValue: 30,
          maxValue: 200,
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
            ref.read(qprovider.notifier).setWeight(value.toDouble());
          },
        ),
      ],
    );
  }

  Widget _buildHeightSection(Qstate qstate) {
    final height = qstate.height ?? 170;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Height',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            Text(
              '${height.toInt()} cm',
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
        SizedBox(height: 12),
        NumberPicker(
          value: height.toInt(),
          minValue: 100,
          maxValue: 250,
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
            ref.read(qprovider.notifier).setHeight(value.toDouble());
          },
        ),
      ],
    );
  }

  Widget _buildBodyTypeSection(Qstate qstate) {
    final selected = qstate.bodyType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'FITNESS GOALS',
              style: TextStyle(
                fontSize: 15,
                color: Colors.cyan,
                fontFamily: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                ).fontFamily,
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Icon(
                FontAwesomeIcons.dumbbell,
                size: 40,
                color: Colors.cyan.withOpacity(0.6),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Text(
          'Body Type',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 10, 6, 37),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: ['Slim', 'Athletic', 'Heavy'].map((bodyType) {
              final isSelected =
                  selected?.toLowerCase() == bodyType.toLowerCase();
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(qprovider.notifier)
                        .setBodyType(bodyType.toLowerCase());
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[700] : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      bodyType,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey.shade500,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalSection(Qstate qstate) {
    final selected = qstate.goal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Goal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 10, 6, 37),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: ['Lose Weight', 'Build Muscle', 'Maintain Fitness'].map((
              goal,
            ) {
              final isSelected = selected?.toLowerCase() == goal.toLowerCase();
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: GestureDetector(
                  onTap: () {
                    ref.read(qprovider.notifier).setGoal(goal.toLowerCase());
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[700] : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      goal,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey.shade500,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final qstate = ref.watch(qprovider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
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
                  'Edit Profile',
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
                  'Update your personal information',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontFamily: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                    ).fontFamily,
                  ),
                ),
                const SizedBox(height: 20.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAgeSection(qstate),
                        SizedBox(height: 30),
                        _buildGenderSection(qstate),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWeightSection(qstate),
                        SizedBox(height: 30),
                        _buildHeightSection(qstate),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Card(
                  color: const Color.fromARGB(255, 8, 13, 30),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBodyTypeSection(qstate),
                        SizedBox(height: 30),
                        _buildGoalSection(qstate),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'SAVE PROFILE',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
