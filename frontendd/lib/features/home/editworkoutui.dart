import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendd/features/home/workoutmapper.dart';

class EditWorkoutUI extends ConsumerWidget {
  const EditWorkoutUI({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyPlan = ref.watch(weeklyPlanProvider);
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final icons = [
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.dumbbell,
      FontAwesomeIcons.bed,
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 10, 10, 10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Weekly Workout Plan',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Info Card
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 7, 26, 41),
                      Color.fromARGB(255, 10, 35, 55),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        FontAwesomeIcons.calendarDays,
                        color: Colors.cyanAccent,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Customize Your Schedule',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Select workout for each day of the week',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              
              // Days List
              ...List.generate(7, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 20, 20),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: weeklyPlan[index] == 'REST DAY' 
                            ? Colors.orange.withOpacity(0.3)
                            : Colors.cyanAccent.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          // Day Icon and Name
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: weeklyPlan[index] == 'REST DAY'
                                  ? Colors.orange.withOpacity(0.15)
                                  : Colors.cyanAccent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              icons[index],
                              color: weeklyPlan[index] == 'REST DAY'
                                  ? Colors.orange
                                  : Colors.cyanAccent,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  days[index],
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  Workoutmapper.getDisplayName(weeklyPlan[index]),
                                  style: GoogleFonts.poppins(
                                    color: weeklyPlan[index] == 'REST DAY'
                                        ? Colors.orange
                                        : Colors.cyanAccent,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Dropdown
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 30, 30, 30),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: DropdownButton<String>(
                              value: weeklyPlan[index],
                              underline: const SizedBox(),
                              dropdownColor: const Color.fromARGB(255, 30, 30, 30),
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white70,
                                size: 20.sp,
                              ),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 13.sp,
                              ),
                              items: Workoutmapper.allworkouttypes.map((String workout) {
                                return DropdownMenuItem<String>(
                                  value: workout,
                                  child: Text(
                                    Workoutmapper.getDisplayName(workout),
                                    style: GoogleFonts.poppins(fontSize: 13.sp),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  ref.read(weeklyPlanProvider.notifier).updateDay(index, newValue);
                                  
                                  // Show feedback
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${days[index]} updated to ${Workoutmapper.getDisplayName(newValue)}',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      duration: const Duration(milliseconds: 1000),
                                      backgroundColor: const Color.fromARGB(255, 20, 80, 100),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              
              SizedBox(height: 20.h),
              
              // Info Footer
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 15, 15, 15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.circleInfo,
                      color: Colors.white54,
                      size: 18.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Changes are saved automatically. Your home screen will reflect this schedule.',
                        style: GoogleFonts.poppins(
                          color: Colors.white54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}