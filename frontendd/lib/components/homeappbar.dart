import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sidebarx/sidebarx.dart';
final sidebarControllerProvider= Provider((ref) => SidebarXController(selectedIndex: 0),);
class HomeAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
   HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: GoogleFonts.oswald().fontFamily,
                      ),
                    ),
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
