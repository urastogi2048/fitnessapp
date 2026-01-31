
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

class Editprofile extends ConsumerStatefulWidget  {
   final UserProfile userProfile;
   const Editprofile({super.key, required this.userProfile});
   @override
  ConsumerState<Editprofile> createState() => _EditprofileState();
}
class _EditprofileState extends ConsumerState<Editprofile>{
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier=ref.read(qprovider.notifier);
      notifier.setAge(widget.userProfile.age ?? 18);
      notifier.setGender(widget.userProfile.gender?.toLowerCase() ?? 'male');
      notifier.setWeight(widget.userProfile.weight?.toDouble() ?? 70.0);
      notifier.setHeight(widget.userProfile.height?.toDouble() ?? 170.0);
      notifier.setBodyType(widget.userProfile.bodyType?.toLowerCase() ?? 'mesomorph');
      notifier.setGoal(widget.userProfile.goal?.toLowerCase() ?? 'maintain fitness');

    });
    
  }

  Future<void> _saveProfile() async {
    setState(()=>_isLoading = true);
    try{
      final state=ref.read(qprovider);
      await QRepo().updateProfile(
        age: state.age!,
        gender: state.gender!,
        weight: state.weight!,
        height: state.height!,
        bodyType: state.bodyType!,
        goal: state.goal!,
      );
      ref.invalidate(profileProvider);
      if(mounted) {
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
          if(mounted) Navigator.pop(context);
        });
      }
    }
    catch(e){
      if(mounted){
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
      if(mounted){
        setState(()=>_isLoading = false);
      }
    }


  }

  
  Widget _buildAgeSection(Qstate qstate) {
    final age = qstate.age ?? 18;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 75, 35, 150).withOpacity(0.3),
            const Color.fromARGB(255, 134, 90, 255).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 134, 90, 255).withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'What is your age?',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.manrope().fontFamily,
              color: const Color.fromARGB(255, 188, 177, 255),
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
                fontSize: 48.sp,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 134, 90, 255),
              ),
            ),
          ),
          Text(
            "years",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontFamily: GoogleFonts.oswald().fontFamily,
            ),
          ),
          SizedBox(height: 16.h),
          NumberPicker(
            value: age,
            minValue: 10,
            maxValue: 100,
            itemHeight: 60,
            axis: Axis.horizontal,
            selectedTextStyle: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
            onChanged: (value) {
              ref.read(qprovider.notifier).setAge(value);
            },
          ),
        ],
      ),
    );
    
  }
  Widget _buildGenderSection(Qstate qstate) {
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
                  ? const Color.fromARGB(255, 134, 90, 255)
                  : const Color.fromARGB(255, 75, 35, 150).withOpacity(0.4),
            ),
            foregroundColor: MaterialStateProperty.all(
              isSelected ? Colors.white : const Color.fromARGB(255, 188, 177, 255),
            ),
            elevation: MaterialStateProperty.all(isSelected ? 8 : 0),
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
            ref.read(qprovider.notifier).setGender(label.toLowerCase());
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 75, 35, 150).withOpacity(0.3),
            const Color.fromARGB(255, 134, 90, 255).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 134, 90, 255).withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'What is your gender?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 188, 177, 255),
            ),
          ),
          SizedBox(height: 16.h),
          option("Male"),
          SizedBox(height: 12.h),
          option("Female"),
        ],
      ),
    );
    
  }
  Widget _buildWeightSection(Qstate qstate) {
    final weight = qstate.weight ?? 70;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 75, 35, 150).withOpacity(0.3),
            const Color.fromARGB(255, 134, 90, 255).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 134, 90, 255).withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'What is your weight (kg)?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 188, 177, 255),
            ),
          ),
          SizedBox(height: 16.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '$weight',
              key: ValueKey(weight),
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: const Color.fromARGB(255, 134, 90, 255),
              ),
            ),
          ),
          Text(
            'kg',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
              fontFamily: GoogleFonts.oswald().fontFamily,
            ),
          ),
          SizedBox(height: 16.h),
          NumberPicker(
            minValue: 25,
            maxValue: 200,
            value: weight.toInt(),
            onChanged: (value) {
              ref.read(qprovider.notifier).setWeight(value.toDouble());
            },
            axis: Axis.horizontal,
            selectedTextStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ],
      ),
    );
    
  }
  Widget _buildHeightSection(Qstate qstate) {
    final height = qstate.height ?? 170;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 75, 35, 150).withOpacity(0.3),
            const Color.fromARGB(255, 134, 90, 255).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 134, 90, 255).withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'What is your height (cm)?',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.manrope().fontFamily,
              color: const Color.fromARGB(255, 188, 177, 255),
            ),
          ),
          SizedBox(height: 16.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: Text(
              '$height',
              key: ValueKey(height),
              style: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 134, 90, 255),
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          Text(
            "cm",
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey.shade500,
              fontFamily: GoogleFonts.oswald().fontFamily,
            ),
          ),
          SizedBox(height: 16.h),
          NumberPicker(
            minValue: 100,
            maxValue: 250,
            value: height.toInt(),
            onChanged: (value) {
              ref.read(qprovider.notifier).setHeight(value.toDouble());
            },
            axis: Axis.horizontal,
            selectedTextStyle: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255),
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
            textStyle: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
              fontFamily: GoogleFonts.manrope().fontFamily,
            ),
          ),
        ],
      ),
    );
    
  }
  Widget _buildBodyTypeSection(Qstate qstate) {
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
                  ? const Color.fromARGB(255, 134, 90, 255)
                  : const Color.fromARGB(255, 75, 35, 150).withOpacity(0.4),
            ),
            foregroundColor: MaterialStateProperty.all(
              isSelected ? Colors.white : const Color.fromARGB(255, 188, 177, 255),
            ),
            elevation: MaterialStateProperty.all(isSelected ? 8 : 0),
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
            ref.read(qprovider.notifier).setBodyType(label.toLowerCase());
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 75, 35, 150).withOpacity(0.3),
            const Color.fromARGB(255, 134, 90, 255).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 134, 90, 255).withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'What is your body type?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 188, 177, 255),
            ),
          ),
          SizedBox(height: 16.h),
          option("Ectomorph"),
          SizedBox(height: 12.h),
          option("Mesomorph"),
          SizedBox(height: 12.h),
          option("Endomorph"),
        ],
      ),
    );
    
  }
  Widget _buildGoalSection(Qstate qstate) {
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
                  ? const Color.fromARGB(255, 134, 90, 255)
                  : const Color.fromARGB(255, 75, 35, 150).withOpacity(0.4),
            ),
            foregroundColor: MaterialStateProperty.all(
              isSelected ? Colors.white : const Color.fromARGB(255, 188, 177, 255),
            ),
            elevation: MaterialStateProperty.all(isSelected ? 8 : 0),
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
            ref.read(qprovider.notifier).setGoal(label.toLowerCase());
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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(255, 75, 35, 150).withOpacity(0.3),
            const Color.fromARGB(255, 134, 90, 255).withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromARGB(255, 134, 90, 255).withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'What is your fitness goal?',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 188, 177, 255),
            ),
          ),
          SizedBox(height: 16.h),
          option("Lose Weight"),
          SizedBox(height: 12.h),
          option("Build Muscle"),
          SizedBox(height: 12.h),
          option("Maintain Fitness"),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final qstate = ref.watch(qprovider);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 7, 31),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              _buildAgeSection(qstate),
              SizedBox(height: 20.h),
              _buildGenderSection(qstate),
              SizedBox(height: 20.h),
              _buildWeightSection(qstate),
              SizedBox(height: 20.h),
              _buildHeightSection(qstate),
              SizedBox(height: 20.h),
              _buildBodyTypeSection(qstate),
              SizedBox(height: 20.h),
              _buildGoalSection(qstate),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 8,
                  ),
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 120, 120, 120),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}