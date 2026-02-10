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
  final authService = ref.read(authServiceProvider);
  final data = await authService.getMe();

  final user = data['user'] as Map<String, dynamic>?;

  if (user == null) {
    throw Exception('User data missing from backend response');
  }

  final profile = UserProfile.fromJson(user);

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
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, stack) => _errorState(context, e, stack, ref),
        data: (profile) {
          final double heightInMeters = (profile.height ?? 0) / 100;
          final double weight = profile.weight ?? 0;
          final double bmi = (heightInMeters > 0)
              ? weight / (heightInMeters * heightInMeters)
              : 0.0;

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(25.0.w),
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
                            size: 15.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                              fontFamily: GoogleFonts.manrope().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 28.sp,
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
                            height: 44.h,
                            width: 44.w,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 6, 25, 41),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              FontAwesomeIcons.gear,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      profile.username.isNotEmpty
                          ? '@${profile.username}'
                          : 'User Profile',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                        fontFamily: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                        ).fontFamily,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Hero User Card
                    Card(
                      color: const Color.fromARGB(255, 8, 13, 30),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Row(
                          children: [
                            Container(
                              height: 70.h,
                              width: 70.w,
                              decoration: BoxDecoration(
                                color: Colors.purpleAccent.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                FontAwesomeIcons.userAstronaut,
                                color: Colors.purpleAccent,
                                size: 32.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.username.isNotEmpty
                                        ? profile.username
                                        : 'User',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily:
                                          GoogleFonts.manrope().fontFamily,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    profile.email.isNotEmpty
                                        ? profile.email
                                        : 'No email',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white70,
                                      fontFamily:
                                          GoogleFonts.manrope().fontFamily,
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
                    SizedBox(height: 24.h),

                    // Metrics Grid
                    Row(
                      children: [
                        Text(
                          'BODY METRICS',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.cyanAccent,
                            fontFamily: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          FontAwesomeIcons.chartLine,
                          color: Colors.cyanAccent,
                          size: 16.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
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
                          profile.height != null
                              ? '${profile.height!.toStringAsFixed(0)}'
                              : '--',
                          'cm',
                          FontAwesomeIcons.rulerVertical,
                          Colors.amberAccent,
                        ),
                        _metricCard(
                          'Weight',
                          profile.weight != null
                              ? '${profile.weight!.toStringAsFixed(0)}'
                              : '--',
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
                    SizedBox(height: 24.h),

                    // Body Profile Section
                    Row(
                      children: [
                        Text(
                          'BODY PROFILE',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.purpleAccent,
                            fontFamily: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                            ).fontFamily,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          FontAwesomeIcons.dna,
                          color: Colors.purpleAccent,
                          size: 16.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    _profileInfoCard(
                      'Body Mass Index',
                      _fallback(bmi.toStringAsFixed(2)),
                      FontAwesomeIcons.weightHanging,
                    ),
                    SizedBox(height: 15.h),
                    _profileInfoCard(
                      'Gender',
                      _fallback(profile.gender),
                      FontAwesomeIcons.venusMars,
                    ),
                    SizedBox(height: 12.h),
                    _profileInfoCard(
                      'Body Type',
                      _fallback(profile.bodyType),
                      FontAwesomeIcons.personRunning,
                    ),
                    SizedBox(height: 32.h),

                    _logoutButton(context, ref),
                    SizedBox(height: 20.h),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 20.sp),
            ),
            SizedBox(height: 8.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (unit.isNotEmpty) ...[
                      SizedBox(width: 4.w),
                      Text(
                        unit,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11.sp,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.purpleAccent, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
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
      {
        'label': 'Age',
        'value': profile.age != null ? '${profile.age} yrs' : 'Not set',
        'icon': Icons.cake_outlined,
        'color': const Color.fromARGB(255, 1, 72, 4),
      },
      {
        'label': 'Height',
        'value': profile.height != null ? '${profile.height} cm' : 'Not set',
        'icon': Icons.height,
        'color': const Color.fromARGB(255, 187, 187, 1),
      },
      {
        'label': 'Weight',
        'value': profile.weight != null ? '${profile.weight} kg' : 'Not set',
        'icon': Icons.monitor_weight_outlined,
        'color': const Color.fromARGB(255, 2, 71, 128),
      },
      {
        'label': 'Goal',
        'value': _fallback(profile.goal),
        'icon': Icons.flag_outlined,
        'color': const Color.fromARGB(255, 136, 7, 7),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.oswald(color: Colors.white70, fontSize: 13.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              value,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16.sp,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(24.0.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.manrope().fontFamily,
              ),
            ),
            SizedBox(height: 24.h),
            _settingsOption(
              icon: FontAwesomeIcons.penToSquare,
              title: 'Edit Profile',
              subtitle: 'Update your questionnaire details',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Editprofile(userProfile: profile),
                  ),
                );
              },
            ),
            SizedBox(height: 12.h),
            _settingsOption(
              icon: FontAwesomeIcons.calendarDays,
              title: 'Set Your Schedule',
              subtitle: 'Manange your weekly workout plan',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditWorkoutUI()),
                );
              },
            ),
            SizedBox(height: 12.h),

            _settingsOption(
              icon: FontAwesomeIcons.circleQuestion,
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpAndSupportPage(),
                  ),
                );
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
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.0.r),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 7, 26, 41),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.cyanAccent, size: 18.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12.sp,
                      fontFamily: GoogleFonts.manrope().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white54,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 64.h,
      child: ElevatedButton(
        onPressed: () async {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (_) => false);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.rightFromBracket, size: 18.sp),
            SizedBox(width: 12.w),
            Text(
              'SIGN OUT',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorState(
    BuildContext context,
    Object e,
    StackTrace stack,
    WidgetRef ref,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30.r),
        child: Card(
          color: const Color.fromARGB(255, 8, 13, 30),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(30.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.redAccent,
                    size: 32.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Error loading profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  e.toString(),
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                    fontFamily: GoogleFonts.manrope().fontFamily,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.arrowsRotate, size: 16.sp),
                        SizedBox(width: 10.w),
                        Text(
                          'RETRY',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
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
