
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../features/auth/authprovider.dart';

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


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: profileAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        error: (e, stack) => _errorState(context, e, stack, ref),
        data: (profile) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section - Title and Settings
                    SizedBox(
                      height: 65.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profile',
                                style: GoogleFonts.openSans(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                profile.username.isNotEmpty ? '@${profile.username}' : 'User Profile',
                                style: GoogleFonts.openSans(
                                  fontSize: 16.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              _showSettingsBottomSheet(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(123, 9, 45, 81),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Hero User Card
                    Card(
                      color: const Color.fromARGB(255, 49, 1, 96),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Row(
                          children: [
                            Container(
                              width: 70.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 255, 87, 51),
                                    Color.fromARGB(255, 221, 44, 0),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(color: Colors.white24, width: 2),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 36.sp,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profile.username.isNotEmpty ? profile.username : 'User',
                                    style: GoogleFonts.openSans(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    profile.email.isNotEmpty ? profile.email : 'No email',
                                    style: GoogleFonts.openSans(
                                      fontSize: 13.sp,
                                      color: Colors.white70,
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
                    Text(
                      'Your Metrics',
                      style: GoogleFonts.openSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
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
                          Icons.cake_outlined,
                          const Color.fromARGB(255, 1, 72, 4),
                        ),
                        _metricCard(
                          'Height',
                          profile.height != null ? '${profile.height!.toStringAsFixed(0)}' : '--',
                          'cm',
                          Icons.height,
                          const Color.fromARGB(255, 187, 187, 1),
                        ),
                        _metricCard(
                          'Weight',
                          profile.weight != null ? '${profile.weight!.toStringAsFixed(0)}' : '--',
                          'kg',
                          Icons.monitor_weight_outlined,
                          const Color.fromARGB(255, 2, 71, 128),
                        ),
                        _metricCard(
                          'Goal',
                          _fallback(profile.goal),
                          '',
                          Icons.flag_outlined,
                          const Color.fromARGB(255, 136, 7, 7),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Body Profile Section
                    Text(
                      'Body Profile',
                      style: GoogleFonts.openSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _profileInfoCard('Gender', _fallback(profile.gender)),
                    SizedBox(height: 12.h),
                    _profileInfoCard('Body Type', _fallback(profile.bodyType)),
                    SizedBox(height: 32.h),

                    // Logout Button
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
    Color bgColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 28.sp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    color: Colors.white70,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (unit.isNotEmpty) ...[
                      SizedBox(width: 4.w),
                      Text(
                        unit,
                        style: GoogleFonts.manrope(
                          color: Colors.white70,
                          fontSize: 11.sp,
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

  Widget _profileInfoCard(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(123, 9, 45, 81),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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

  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.openSans(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            _settingsOption(
              icon: Icons.edit,
              title: 'Edit Profile',
              subtitle: 'Update your questionnaire details',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile feature coming soon')),
                );
              },
            ),
            SizedBox(height: 12.h),
            _settingsOption(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Manage workout reminders',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notification settings coming soon')),
                );
              },
            ),
            SizedBox(height: 12.h),
            _settingsOption(
              icon: Icons.privacy_tip,
              title: 'Privacy',
              subtitle: 'Privacy and security settings',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Privacy settings coming soon')),
                );
              },
            ),
            SizedBox(height: 12.h),
            _settingsOption(
              icon: Icons.help,
              title: 'Help & Support',
              subtitle: 'Get help with the app',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Support page coming soon')),
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
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color.fromARGB(123, 9, 45, 81),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      color: Colors.white70,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, WidgetRef ref) {
    return Card(
      color: const Color.fromARGB(255, 136, 7, 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, Object e, StackTrace stack, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: const Color.fromARGB(255, 136, 7, 7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.amber, size: 54),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: GoogleFonts.oswald(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color.fromARGB(255, 136, 7, 7),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  ),
                  onPressed: () => ref.invalidate(profileProvider),
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