import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:frontendd/features/home/streakservice.dart';
//import 'package:on_popup_window_widget/on_popup_window_widget.dart';
final sidebarControllerProvider= Provider((ref) => SidebarXController(selectedIndex: 0),);
class HomeAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
   HomeAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(72.h);
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: preferredSize.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB11226), Color(0xFFE53935)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  // Sidebar toggle button
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      ref.read(sidebarControllerProvider).toggleExtended();
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "FitWell",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: GoogleFonts.oswald().fontFamily,
                      ),
                    ),
                    
                    
                  ),
                  streak.when(
                      loading: () => const SizedBox.shrink(),
                      error: (err, stack) => const SizedBox.shrink(),
                      data: (streak) => InkWell(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color.fromARGB(255, 30, 7, 7),
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(streak.currentStreak > 0)
                                    Text(
                                      "Keep it going! You're on fire.",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[300],
                                        fontSize: 14,
                                      ),
                                    )
                                  else
                                    Text("Prioritize yourself! Get the streak movin'", 
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[300],
                                        fontSize: 14,
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 220, 50, 50).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color.fromARGB(255, 220, 50, 50),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Current Streak",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${streak.currentStreak} days",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Best Streak",
                                              style: GoogleFonts.poppins(
                                                color: Colors.grey[400],
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${streak.longestStreak} days",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
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
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 220, 50, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
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
                        child: Row(children: [
                          Lottie.asset(
                            'assets/lottie/streak.json',
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${streak.currentStreak}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],),
                      )
                    ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
