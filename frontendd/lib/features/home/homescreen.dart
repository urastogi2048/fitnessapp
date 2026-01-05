import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendd/components/customappbar.dart';
import 'package:frontendd/features/auth/authprovider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends ConsumerState<HomeScreen> {
   late InfiniteScrollController controller;
       Timer? _timer;
       final List<String> carouselimages = [
        'assets/images/carousel.jpg',
        'assets/images/carousel2.jpg',
        'assets/images/carousel3.jpg',
        'assets/images/carousel4.jpg',
       ];
    @override
  void initState() {
    super.initState();
    controller = InfiniteScrollController();
   
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (controller.hasClients) {
        controller.nextItem();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      final authstate = ref.watch(authProvider);
     final name = authstate.username ?? "User";
      final String today = DateFormat('EEEE').format(DateTime.now());
      final List<String> weekdays = ['Upper Body Strength', 'Lower Body Strength', 'Cardio Endurance', 'Core Stability', 'Flexibility Training', 'Full Body Workout', 'Rest Day'];
      
        return Scaffold(
          appBar: CustomAppBar(title: "Hey $name"),
          backgroundColor: Color.fromARGB(255, 31, 7, 7),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            
            children: [
               InkWell(
                onTap: () => print("pressed"),            
                  child : SizedBox(
                  height: 160,
                  width: double.infinity,
                  
                  child: Card(
                    color: const Color.fromARGB(255, 2, 71, 128),
                    child : Row(
                      children: [
                        Lottie.asset(
                          'assets/lottie/weight.json',
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ( Text ("Continue your weekly workout plan", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),)),
                            SizedBox(height: 15),
                        ( Text ("$today: ${weekdays[DateTime.now().weekday - 1]}", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: GoogleFonts.oswald().fontFamily),)),
                            ],
                          ),
                        ),
                      ],
                    )
                  )
                )
               ),
               Row(
                 children: [
                   InkWell(
                    onTap: () => print("pressed"),            
                      child : SizedBox(
                      height: 160,
                      width: MediaQuery.of(context).size.width/2 - 16,
                      
                      child: Card(
                        color: const Color.fromARGB(255, 1, 72, 4),
                        child : Row(
                          children: [
                            Lottie.asset(
                              'assets/lottie/bodypart.json',
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                            Expanded(child: Text ("Train body part", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),)),
                          ],
                        )
                      )
                    )
                   ),
                   InkWell(
                    onTap: () => print("pressed"),            
                      child : SizedBox(
                      height: 160,
                      width: MediaQuery.of(context).size.width/2 - 16,
                      
                      child: Card(
                        color: const Color.fromARGB(255, 187, 187, 1),
                        child : Row(
                          children: [
                            Lottie.asset(
                              'assets/lottie/growth.json',
                              width: 80,
                              height: 80,
                              fit: BoxFit.fill,
                            ),
                            Expanded(child: Text ("Track your progress", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),)),
                          ],
                        )
                      )
                    )
                   ),
                 ],
               ),
               SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: InfiniteCarousel.builder(
                    itemCount: carouselimages.length,
                    itemExtent: MediaQuery.of(context).size.width*0.8,
                    center: true,
                    controller: controller,
                    loop: true,
                    itemBuilder: (context, itemIndex, realIndex) {
                      final imagePath = carouselimages[itemIndex];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                onTap: () => print("pressed"),            
                  child : SizedBox(
                  height: 160,
                  width: double.infinity,
                  
                  child: Card(
                    color: const Color.fromARGB(255, 49, 1, 96),
                    child : Row(
                      children: [
                        Lottie.asset(
                          'assets/lottie/Fitness.json',
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ( Text ("Recovery Readiness Score", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),)),
                            SizedBox(height: 15),
                        ( Text ("Your smart postworkout assistant!!", style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: GoogleFonts.oswald().fontFamily),)),
                            ],
                          ),
                        ),
                      ],
                    )
                  )
                )
               )

            ],
          ),
        ),

      ),
    );
  }
}