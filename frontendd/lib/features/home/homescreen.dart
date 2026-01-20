import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/components/homeappbar.dart';
import 'package:frontendd/features/home/profile.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late InfiniteScrollController carouselController;
  Timer? _timer;


  int selectedIndex = 0;

  final List<String> carouselimages = [
    'assets/images/carousel.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpg',
    'assets/images/carousel4.jpg',
  ];

  @override
  void initState() {
  super.initState();
  carouselController = InfiniteScrollController();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (carouselController.hasClients) {
        carouselController.nextItem();
      }
    });
  });
}

  @override
  void dispose() {
    _timer?.cancel();
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String today =
        DateFormat('EEEE').format(DateTime.now());

    final List<String> weekdays = [
      'Chest',
      'Back',
      'Legs',
      'Shoulders',
      'Arms',
      'Core + Cardio',
      'Rest Day'
    ];

    return Scaffold(
      appBar: HomeAppBar(),
      backgroundColor: const Color.fromARGB(255, 31, 7, 7),

      body: IndexedStack(
        index: selectedIndex,
        children: [
          // Home screen
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  
                  InkWell(
                    onTap: () {
                      if(today == 'Sunday'){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("It's Rest Day! Take a break and recharge for the week ahead."),
                          ),
                        );
                         
                      }
                       else if(today == 'Monday'){
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionPage(
                                exercises: ExerciseData.getExercises(BodyPart.chest),
                                bodyPart: BodyPart.chest,
                              ),
                            ),
                          );
                        }
                      } else if(today == 'Tuesday'){
                        if (context.mounted) {
                          Navigator.push( 
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionPage(
                                exercises: ExerciseData.getExercises(BodyPart.back),
                                bodyPart: BodyPart.back,
                              ),
                            ),
                          );
                        }
                      }
                      else if(today == 'Wednesday'){
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionPage(
                                exercises: ExerciseData.getExercises(BodyPart.legs),
                                bodyPart: BodyPart.legs,
                              ),
                            ),
                          );
                        }
                      }
                      else if(today == 'Thursday'){
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionPage(
                                exercises: ExerciseData.getExercises(BodyPart.shoulders),
                                bodyPart: BodyPart.shoulders,
                              ),
                            ),
                          );
                        }
                      }
                      else if(today == 'Friday'){
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionPage(
                                exercises: ExerciseData.getExercises(BodyPart.arms),
                                bodyPart: BodyPart.arms,
                              ),
                            ),
                          );
                        }
                      }
                      else if(today == 'Saturday'){
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExerciseExecutionPage(
                                exercises: ExerciseData.getExercises(BodyPart.core),
                                bodyPart: BodyPart.core,
                              ),
                            ),
                          );
                        }
                      }

                    },
                    child: SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: Card(
                        color:
                            const Color.fromARGB(255, 2, 71, 128),
                        child: Row(
                          children: [
                            Lottie.asset(
                              'assets/lottie/weight.json',
                              width: 120,
                              height: 120,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Continue your weekly workout plan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily:
                                          GoogleFonts.poppins()
                                              .fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "$today: ${weekdays[DateTime.now().weekday - 1]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily:
                                          GoogleFonts.oswald()
                                              .fontFamily,
                                    ),
                                  ),
                                ],
                              ),
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
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: _smallCard(
                            color:
                                const Color.fromARGB(255, 1, 72, 4),
                            lottie: 'assets/lottie/bodypart.json',
                            text: "Train body part",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                          
                          },
                          child: _smallCard(
                            color:
                                const Color.fromARGB(255, 187, 187, 1),
                            lottie: 'assets/lottie/growth.json',
                            text: "Track your progress",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    height: 200,
                    child: InfiniteCarousel.builder(
                      itemCount: carouselimages.length,
                      itemExtent:
                          MediaQuery.of(context).size.width * 0.8,
                      center: true,
                      controller: carouselController,
                      loop: true,
                      itemBuilder:
                          (context, itemIndex, realIndex) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            key: ValueKey('carousel_$itemIndex'),
                            borderRadius:
                                BorderRadius.circular(16),
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

                  InkWell(
                    onTap: (){
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Recoveryreadinesscard(),
                          ),
                        );
                      }
                    },
                    child: _bigCard(
                      color:
                          const Color.fromARGB(255, 49, 1, 96),
                      lottie: 'assets/lottie/Fitness.json',
                      title: "Recovery Readiness Score",
                      subtitle:
                          "Your smart post-workout assistant!!",
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Workouts screen
          Consumer(builder: (context, ref, child) {
            return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildWorkoutCard(
                    context,
                    'Chest Workout',
                    BodyPart.chest,
                    Icons.fitness_center,
                    ref,
                  ),
                  _buildWorkoutCard(
                    context,
                    'Leg Workout',
                    BodyPart.legs,
                    Icons.directions_run,
                    ref,
                  ),
                  _buildWorkoutCard(
                    context,
                    'Back Workout',
                    BodyPart.back,
                    Icons.self_improvement,
                    ref,
                  ),
                  _buildWorkoutCard(
                    context,
                    'Arms Workout',
                    BodyPart.arms,
                    Icons.sports_martial_arts,
                    ref,
                  ),
                  _buildWorkoutCard(
                    context,
                    'Shoulder Workout',
                    BodyPart.shoulders,
                    Icons.accessibility_new,
                    ref,
                  ),
                  _buildWorkoutCard(
                    context,
                    'Core Workout',
                    BodyPart.core,
                    Icons.shield_moon,
                    ref,
                  ),
                  _buildWorkoutCard(
                    context,
                    'Cardio Workout',
                    BodyPart.cardio,
                    Icons.favorite,
                    ref,
                  ),
                ]);
          }),

          // Profile screen
          ProfileScreen(),  
        ],
      ),

     
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: const Color(0xFF121212),
        activeColor: Colors.redAccent,
        iconSize: 28,
        selectedIndex: selectedIndex,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        barItems:  [
          BarItem(icon: Icons.home, title: 'Home'),
          BarItem(icon: Icons.fitness_center, title: 'Workouts'),
          BarItem(icon: Icons.person, title: 'Profile'),
        ],
      ),
    );
  }


  Widget _bigCard({
    required Color color,
    required String lottie,
    required String title,
    required String subtitle,
  }) {
    return SizedBox(
      height: 160,
      child: Card(
        color: color,
        child: Row(
          children: [
            Lottie.asset(lottie, width: 120, height: 120),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins()
                          .fontFamily,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subtitle,
                    style:
                        TextStyle(color: Colors.white70, fontFamily: GoogleFonts.oswald().fontFamily),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCard({
    required Color color,
    required String lottie,
    required String text,
  }) {
    return SizedBox(
      height: 140,
      child: Card(
        color: color,
        child: Row(
          children: [
            Lottie.asset(lottie, width: 70, height: 70),
            Expanded(
              child: Text(
                text,
                style:  TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
          ],
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
  ) {
    return Card(
      color: const Color.fromARGB(255, 136, 7, 7),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color.fromARGB(255, 4, 4, 4), size: 40),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
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
      ),
    );
  }
}
