import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:frontendd/features/home/bmicalc.dart';
import 'package:frontendd/features/home/profile.dart';
import 'package:frontendd/features/progress/statui.dart';
import 'package:frontendd/features/recoveryfeature/recoveryreadinesscard.dart';
import 'package:frontendd/features/weeklyworkout/exercisedata.dart';
import 'package:frontendd/features/weeklyworkout/exercisemodel.dart';
import 'package:frontendd/features/weeklyworkout/exerciseui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:frontendd/features/home/profile.dart' show profileProvider;
import 'package:frontendd/features/home/streakservice.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendd/services/notificationservice.dart';
import 'package:frontendd/features/home/workoutmapper.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late InfiniteScrollController carouselController;
  Timer? _timer;
  Timer? _streakTimer;

  int selectedIndex = 0;
  final date = DateTime.now();
  final day = DateTime.now().day;
  final List<String> carouselimages = [
    'assets/images/carousel.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpg',
    'assets/images/carousel4.jpg',
    'assets/images/carousel5.jpg',
    'assets/images/carousel6.png',
    'assets/images/carousel7.png',
    'assets/images/carousel8.png',
    'assets/images/carousel9.png',
    'assets/images/carousel10.png',
    'assets/images/carousel11.png',
    'assets/images/carousel12.png',
  ];

  @override
  void initState() {
    super.initState();
    carouselController = InfiniteScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(streakProvider);
      _streakTimer = Timer.periodic(
        const Duration(seconds: 20),
        (_) => ref.invalidate(streakProvider),
      );

      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (carouselController.hasClients) {
          carouselController.nextItem();
        }
      });
    });
  }

  @override
  void dispose() {
    _streakTimer?.cancel();
    _timer?.cancel();
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('EEEE').format(DateTime.now());
    final streak = ref.watch(streakProvider);

    // final List<String> weekdays = [
    //   'CHEST DAY',
    //   'BACK DAY',
    //   'LEG DAY',
    //   'SHOULDERS DAY',
    //   'ARMS DAY',
    //   'CORE + CARDIO DAY',
    //   'REST DAY',
    // ];
    final weekdays = ref.watch(weeklyPlanProvider);
    String workout = weekdays[DateTime.now().weekday - 1];
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),

        body: IndexedStack(
          index: selectedIndex,
          children: [
            // Home screen
            // Text(
            //   'Fitwell',
            //   style: GoogleFonts.poppins(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Fitness Dude',
                                style: GoogleFonts.openSans(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${today.substring(0, 3)}, $day ${DateFormat.MMM().format(date)}",
                                style: GoogleFonts.openSans(
                                  fontSize: 16.sp,
                                  color: Colors.white70,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),

                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BMICalculator(),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.weightScale,
                                  color: Colors.blueAccent,
                                  size: 20.sp,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'BMI',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Calc',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 8.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Flexible(
                          flex: 1,
                          child: streak.when(
                            loading: () => const SizedBox.shrink(),
                            error: (err, stack) => const SizedBox.shrink(),
                            data: (streak) => InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      30,
                                      7,
                                      7,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 220, 50, 50),
                                        width: 2,
                                      ),
                                    ),
                                    title: Text(
                                      "Your Streak 🔥",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (streak.currentStreak > 0)
                                          Text(
                                            "Keep it going! You're on fire.",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[300],
                                              fontSize: 14.sp,
                                            ),
                                          )
                                        else
                                          Text(
                                            "Prioritize yourself! Get the streak movin'",
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[300],
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                        SizedBox(height: 20.h),
                                        Container(
                                          padding: EdgeInsets.all(14.w),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                              255,
                                              220,
                                              50,
                                              50,
                                            ).withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                255,
                                                220,
                                                50,
                                                50,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Current Streak",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey[400],
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    "${streak.currentStreak} days",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 24.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "Best Streak",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey[400],
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    "${streak.longestStreak} days",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 24.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                            255,
                                            220,
                                            50,
                                            50,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Close',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.fireFlameCurved,
                                      color: Colors.orange,
                                      size: 24.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Flexible(
                                      child: Text(
                                        '${streak.currentStreak}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Consumer(
                      builder: (context, ref, child) {
                        final profileAsync = ref.watch(profileProvider);

                        return Container(
                          constraints: BoxConstraints(
                            minHeight: 160.h,
                            maxHeight: 220.h,
                          ),
                          width: double.infinity,
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 47, 25, 25),
                                    Color.fromARGB(255, 104, 17, 17),
                                  ],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  final todayWorkout =
                                      weekdays[DateTime.now().weekday - 1];
                                  final bodyPart = Workoutmapper.getBodyPart(
                                    todayWorkout,
                                  );

                                  if (bodyPart == null) {
                                    // Rest Day
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "It's Rest Day! Take a break and recharge for the week ahead.",
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Navigate to workout with user's goal
                                    profileAsync.whenData((profile) {
                                      final goal = profile.goal ?? 'balanced';
                                      final exercises = ExerciseData.getExercises(
                                        bodyPart,
                                        goal: goal,
                                      );

                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ExerciseExecutionPage(
                                              exercises: exercises,
                                              bodyPart: bodyPart,
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 20.h,
                                      right: 20.w,
                                      child: Opacity(
                                        opacity: 0.5,
                                        child: Icon(
                                          FontAwesomeIcons.arrowRight,
                                          color: const Color.fromARGB(
                                            255,
                                            175,
                                            173,
                                            173,
                                          ),
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20.r),
                                        ),
                                        child: Opacity(
                                          opacity: 0.80,
                                          child: Image.asset(
                                            'assets/images/Symbol.png',
                                            width: 120.w,
                                            height: 120.h,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Main co
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Top section with label
                                        Padding(
                                          padding: EdgeInsets.all(16.w),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12.w,
                                              vertical: 6.h,
                                            ),
                                            decoration: ShapeDecoration(
                                              color: const Color(0x33EF4444),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
                                              ),
                                            ),
                                            child: Text(
                                              'TODAY\'S FOCUS',
                                              style: TextStyle(
                                                color: const Color(0xFFF87171),
                                                fontSize: 10.sp,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                letterSpacing: 0.50,
                                              ),
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 12.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  workout,
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      210,
                                                      200,
                                                      200,
                                                    ),
                                                    fontSize: 32.sp,
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w900,
                                                    height: 1.1,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  'Tap to start your workout',
                                                  style: TextStyle(
                                                    color: const Color.fromARGB(
                                                      255,
                                                      149,
                                                      142,
                                                      142,
                                                    ),
                                                    fontSize: 12.sp,
                                                    fontFamily:
                                                        GoogleFonts.poppins()
                                                            .fontFamily,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 90.h,
                        maxHeight: 120.h,
                      ),
                      width: double.infinity,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        color: const Color.fromARGB(255, 8, 13, 30),
                        child: InkWell(
                          onTap: () {
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Recoveryreadinesscard(),
                                ),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  FontAwesomeIcons.heartPulse,
                                  color: const Color.fromARGB(255, 110, 8, 118),
                                  size: 36.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Recovery Score',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        fontFamily:
                                            GoogleFonts.manrope().fontFamily,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Ready to train? See your recovery score.',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11.sp,
                                        fontFamily:
                                            GoogleFonts.manrope().fontFamily,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                FontAwesomeIcons.arrowUpRightDots,
                                color: const Color.fromARGB(179, 117, 116, 116),
                                size: 14.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _smallCard(
                            onTap: () {
                              setState(() {
                                selectedIndex = 1;
                              });
                            },
                            color: const Color.fromARGB(255, 8, 13, 30),
                            // lottie: 'assets/lottie/bodypart.json',
                            text: "Custom",
                            icon: FontAwesomeIcons.dumbbell,
                            minitext: "Choose your workout",
                            iconColor: Colors.blue,
                            iconSize: 42.sp,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _smallCard(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StatsUI(),
                                ),
                              );
                            },
                            color: Color.fromARGB(255, 8, 13, 30),
                            //lottie: 'assets/lottie/growth.json',
                            text: "Progress",
                            minitext: "View analytics",
                            icon: FontAwesomeIcons.chartLine,
                            iconColor: const Color.fromARGB(
                                255,
                                161,
                                170,
                                34,
                              ),
                            iconSize: 42.sp,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 180.h,
                      child: InfiniteCarousel.builder(
                        itemCount: carouselimages.length,
                        itemExtent: MediaQuery.of(context).size.width * 0.8,
                        center: true,
                        controller: carouselController,
                        loop: true,
                        itemBuilder: (context, itemIndex, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              key: ValueKey('carousel_$itemIndex'),
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                carouselimages[itemIndex],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Workouts screen
            Consumer(
              builder: (context, ref, child) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              FontAwesomeIcons.arrowLeft,
                              color: Colors.grey,
                              size: 15.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Home',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: GoogleFonts.manrope().fontFamily,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'Workouts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 20.h),

                    _buildWorkoutCard(
                      context,
                      'Chest Workout',
                      BodyPart.chest,
                      Icons.fitness_center,
                      ref,
                      const Color.fromARGB(132, 255, 82, 82),
                    ),
                    _buildWorkoutCard(
                      context,
                      'Leg Workout',
                      BodyPart.legs,
                      Icons.directions_run,
                      ref,
                      const Color.fromARGB(156, 255, 235, 59),
                    ),
                    _buildWorkoutCard(
                      context,
                      'Back Workout',
                      BodyPart.back,
                      Icons.self_improvement,

                      ref,
                      const Color.fromARGB(144, 33, 149, 243),
                    ),
                    _buildWorkoutCard(
                      context,
                      'Arms Workout',
                      BodyPart.arms,
                      Icons.sports_martial_arts,
                      ref,
                      const Color.fromARGB(136, 156, 39, 176),
                    ),
                    _buildWorkoutCard(
                      context,
                      'Shoulder Workout',
                      BodyPart.shoulders,
                      Icons.accessibility_new,
                      ref,
                      const Color.fromARGB(136, 0, 188, 212),
                    ),
                    _buildWorkoutCard(
                      context,
                      'Core Workout',
                      BodyPart.core,
                      Icons.shield_moon,
                      ref,
                      const Color.fromARGB(136, 76, 175, 80),
                    ),
                    _buildWorkoutCard(
                      context,
                      'Cardio Workout',
                      BodyPart.cardio,
                      Icons.favorite,
                      ref,
                      const Color.fromARGB(136, 255, 87, 34),
                    ),
                  ],
                );
              },
            ),

            // Profile screen
            ProfileScreen(
              onBackToHome: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ),
          ],
        ),

        bottomNavigationBar: SlidingClippedNavBar(
          backgroundColor: const Color(0xFF121212),
          activeColor: Colors.redAccent,
          iconSize: 24.sp,
          selectedIndex: selectedIndex,
          onButtonPressed: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          barItems: [
            BarItem(icon: Icons.home, title: 'Home'),
            BarItem(icon: Icons.fitness_center, title: 'Workouts'),
            BarItem(icon: Icons.person, title: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _smallCard({
    required Color color,
    //required String lottie,
    required String text,
    required IconData icon,
    required String minitext,
    Color? iconColor,
    double? iconSize,
    VoidCallback? onTap,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 120.h, maxHeight: 160.h),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lottie.asset(lottie, width: 70, height: 70),
                    Icon(
                      icon,
                      color: iconColor ?? Colors.white,
                      size: iconSize ?? 42.sp,
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: Text(
                        minitext,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 155, 152, 152),
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      FontAwesomeIcons.arrowUpRightFromSquare,
                      color: const Color.fromARGB(255, 175, 173, 173),
                      size: 14.sp,
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

  Widget _buildWorkoutCard(
    BuildContext context,
    String title,
    BodyPart bodyPart,
    IconData icon,
    WidgetRef ref,
    Color? color,
  ) {
    // Get exercise count for the body part
    final profileAsync = ref.watch(profileProvider);
    int exerciseCount = 8; // default

    profileAsync.whenData((profile) {
      final goal = profile.goal ?? 'balanced';
      final exercises = ExerciseData.getExercises(bodyPart, goal: goal);
      exerciseCount = exercises.length;
    });

    return Card(
      clipBehavior: Clip.antiAlias,
      color: const Color.fromARGB(255, 8, 13, 30), // dark neon blue base
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final profileAsync = ref.watch(profileProvider);

          profileAsync.whenData((profile) {
            final goal = profile.goal ?? 'balanced';
            final exercises = ExerciseData.getExercises(bodyPart, goal: goal);

            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseExecutionPage(
                    exercises: exercises,
                    bodyPart: bodyPart,
                  ),
                ),
              );
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                height: 44.h,
                width: 44.w,

                decoration: BoxDecoration(
                  color:
                      color?.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color ?? Colors.white, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title.replaceAll(' Workout', ' Day'),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$exerciseCount Exercises • 45m',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12.sp,
                        fontFamily: GoogleFonts.manrope().fontFamily,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Play button
              Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
