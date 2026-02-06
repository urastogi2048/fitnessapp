
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontendd/features/home/editprofile.dart';
import 'package:frontendd/features/home/editworkoutui.dart';
import 'package:frontendd/features/home/help&support.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../features/auth/authprovider.dart';
import 'package:frontendd/services/notificationservice.dart';

final profileProvider = FutureProvider<UserProfile>((ref) async {
  print('🔍 ProfileProvider: Starting to fetch user profile...');
  
  final authService = ref.read(authServiceProvider);
  final data = await authService.getMe();
  
  print('📦 ProfileProvider: Raw response data: $data');
  
  final user = data['user'] as Map<String, dynamic>?;
  
  if (user == null) {
    print('❌ ProfileProvider: User data is null in response');
    throw Exception('User data missing from backend response');
  }
  
  print('👤 ProfileProvider: User data received: $user');
  print('📋 ProfileProvider: Profile field: ${user['profile']}');
  
  final profile = UserProfile.fromJson(user);
  print('✅ ProfileProvider: Successfully parsed profile - username: ${profile.username}, email: ${profile.email}');
  print('🏋️ ProfileProvider: Profile details - age: ${profile.age}, height: ${profile.height}, weight: ${profile.weight}');
  
  return profile;
});

class UserProfile {
  final String username;
  final String email;
  final int? age;
  final double? height;
  final double? weight;
  final String? goal;
  final String? gender;
  final String? bodyType;

  const UserProfile({
    required this.username,
    required this.email,
    this.age,
    this.height,
    this.weight,
    this.goal,
    this.gender,
    this.bodyType,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final profile = (json['profile'] as Map<String, dynamic>?) ?? {};

    return UserProfile(
      username: (json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      age: profile['age'] is int
          ? profile['age'] as int
          : (profile['age'] as num?)?.toInt(),
      height: (profile['height'] as num?)?.toDouble(),
      weight: (profile['weight'] as num?)?.toDouble(),
      goal: profile['goal'] as String?,
      gender: profile['gender'] as String?,
      bodyType: profile['bodyType'] as String?,
    );
  }
}


class ProfileScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBackToHome;
  
  const ProfileScreen({super.key, this.onBackToHome});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (e, stack) => _errorState(context, e, stack, ref),
        data: (profile) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    InkWell(
                      onTap: () {
                        if (widget.onBackToHome != null) {
                          widget.onBackToHome!();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Colors.grey,
                            size: 15,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.manrope().fontFamily,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _showSettingsBottomSheet(context, profile);
                          },
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 6, 25, 41),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              FontAwesomeIcons.gear,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      profile.username.isNotEmpty ? '@${profile.username}' : 'User Profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontFamily: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                    const SizedBox(height: 20.0),

                    // Hero User Card
                    Card(
                    color: const Color.fromARGB(255, 8, 13, 30),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                FontAwesomeIcons.userAstronaut,
                                color: Colors.purpleAccent,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.username.isNotEmpty ? profile.username : 'User',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: GoogleFonts.manrope().fontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    profile.email.isNotEmpty ? profile.email : 'No email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                      fontFamily: GoogleFonts.manrope().fontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Metrics Grid
                    Row(
                      children: [
                        Text(
                          'BODY METRICS',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.cyanAccent,
                            fontFamily: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          FontAwesomeIcons.chartLine,
                          color: Colors.cyanAccent,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.15,
                      children: [
                        _metricCard(
                          'Age',
                          profile.age != null ? '${profile.age}' : '--',
                          'years',
                          FontAwesomeIcons.cakeCandles,
                          Colors.greenAccent,
                        ),
                        _metricCard(
                          'Height',
                          profile.height != null ? '${profile.height!.toStringAsFixed(0)}' : '--',
                          'cm',
                          FontAwesomeIcons.rulerVertical,
                          Colors.amberAccent,
                        ),
                        _metricCard(
                          'Weight',
                          profile.weight != null ? '${profile.weight!.toStringAsFixed(0)}' : '--',
                          'kg',
                          FontAwesomeIcons.weightScale,
                          Colors.blueAccent,
                        ),
                        _metricCard(
                          'Goal',
                          _fallback(profile.goal),
                          '',
                          FontAwesomeIcons.bullseye,
                          Colors.orangeAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Body Profile Section
                    Row(
                      children: [
                        Text(
                          'BODY PROFILE',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.purpleAccent,
                            fontFamily: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          FontAwesomeIcons.dna,
                          color: Colors.purpleAccent,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _profileInfoCard('Gender', _fallback(profile.gender), FontAwesomeIcons.venusMars),
                    const SizedBox(height: 12),
                    _profileInfoCard('Body Type', _fallback(profile.bodyType), FontAwesomeIcons.personRunning),
                    const SizedBox(height: 32),

                    // Logout Button
                    _logoutButton(context, ref),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _metricCard(
    String label,
    String value,
    String unit,
    IconData icon,
    Color accentColor,
  ) {
    return Card(
      color: const Color.fromARGB(255, 8, 13, 30),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      Text(
                        unit,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontFamily: GoogleFonts.manrope().fontFamily,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileInfoCard(String label, String value, IconData icon) {
    return Card(
      color: const Color.fromARGB(255, 8, 13, 30),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.purpleAccent, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metrics(UserProfile profile) {
    final metrics = [
      {'label': 'Age', 'value': profile.age != null ? '${profile.age} yrs' : 'Not set', 'icon': Icons.cake_outlined, 'color': const Color.fromARGB(255, 1, 72, 4)},
      {'label': 'Height', 'value': profile.height != null ? '${profile.height} cm' : 'Not set', 'icon': Icons.height, 'color': const Color.fromARGB(255, 187, 187, 1)},
      {'label': 'Weight', 'value': profile.weight != null ? '${profile.weight} kg' : 'Not set', 'icon': Icons.monitor_weight_outlined, 'color': const Color.fromARGB(255, 2, 71, 128)},
      {'label': 'Goal', 'value': _fallback(profile.goal), 'icon': Icons.flag_outlined, 'color': const Color.fromARGB(255, 136, 7, 7)},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final item = metrics[index];
        return _metricCard(
          item['label'] as String,
          item['value'] as String,
          '',
          item['icon'] as IconData,
          item['color'] as Color,
        );
      },
    );
  }

  Widget _metricCardOld({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.oswald(
                color: Colors.white70,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 10, 10, 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            const SizedBox(height: 24),
            _settingsOption(
              icon: FontAwesomeIcons.penToSquare,
              title: 'Edit Profile',
              subtitle: 'Update your questionnaire details',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  Editprofile(userProfile: profile)));
              },
            ),
            const SizedBox(height: 12),
            _settingsOption(
              icon: FontAwesomeIcons.calendarDays,
              title: 'Set Your Schedule',
              subtitle: 'Manange your weekly workout plan',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditWorkoutUI()));
              },
                
            ),
            const SizedBox(height: 12),
            
            _settingsOption(
              icon: FontAwesomeIcons.circleQuestion,
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpAndSupportPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 7, 26, 41),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.cyanAccent, size: 18),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white54,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.rightFromBracket, size: 18),
            const SizedBox(width: 12),
            Text(
              'SIGN OUT',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  } 
  

  Widget _errorState(BuildContext context, Object e, StackTrace stack, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Card(
          color: const Color.fromARGB(255, 8, 13, 30),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.redAccent,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Error loading profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  e.toString(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(FontAwesomeIcons.arrowsRotate, size: 16),
                        const SizedBox(width: 10),
                        Text(
                          'RETRY',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
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

  String _fallback(String? value) {
    if (value == null) return 'Not set';
    if (value.trim().isEmpty) return 'Not set';
    return value;
  }
}