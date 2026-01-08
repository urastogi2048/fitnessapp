import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/components/homeappbar.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:frontendd/features/home/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

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
    final name =
      ref.watch(authProvider.select((s) => s.username)) ?? "User";

    final String today =
        DateFormat('EEEE').format(DateTime.now());

    final List<String> weekdays = [
      'Upper Body Strength',
      'Lower Body Strength',
      'Cardio Endurance',
      'Core Stability',
      'Flexibility Training',
      'Full Body Workout',
      'Rest Day'
    ];

    return Scaffold(
      appBar: HomeAppBar(),
      backgroundColor: const Color.fromARGB(255, 31, 7, 7),

      body: IndexedStack(
        index: selectedIndex,
        children: [
         
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        "Hi, $name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
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
                        child: _smallCard(
                          color:
                              const Color.fromARGB(255, 1, 72, 4),
                          lottie: 'assets/lottie/bodypart.json',
                          text: "Train body part",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _smallCard(
                          color:
                              const Color.fromARGB(255, 187, 187, 1),
                          lottie: 'assets/lottie/growth.json',
                          text: "Track your progress",
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

                  _bigCard(
                    color:
                        const Color.fromARGB(255, 49, 1, 96),
                    lottie: 'assets/lottie/Fitness.json',
                    title: "Recovery Readiness Score",
                    subtitle:
                        "Your smart post-workout assistant!!",
                  ),
                ],
              ),
            ),
          ),

          ProfileScreen(),

          const Center(
            child: Text(
              "Workouts Page",
              style: TextStyle(color: Colors.white),
            ),
          ),
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
          BarItem(icon: Icons.person, title: 'Profile'),
          BarItem(icon: Icons.fitness_center, title: 'Workouts'),
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
}
