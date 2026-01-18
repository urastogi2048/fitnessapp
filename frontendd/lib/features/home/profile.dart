// Profile Screen for Fitness App
// Shows fetched questionnaire/profile details + Logout

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 72,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: _softIcon(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
        title: Text(
          'Profile',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _softIcon(icon: Icons.more_horiz, onTap: () {}),
          )
        ],
      ),
      body: Stack(
        children: [
          _backgroundDecor(),
          profileAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (e, stack) => _errorState(context, e, stack, ref),
            data: (profile) {
              print('🎨 Rendering profile screen with data:');
              print('   Username: "${profile.username}" (empty: ${profile.username.isEmpty})');
              print('   Email: "${profile.email}" (empty: ${profile.email.isEmpty})');
              print('   Age: ${profile.age}');
              print('   Height: ${profile.height}');
              print('   Weight: ${profile.weight}');
              print('   Goal: ${profile.goal}');
              print('   Gender: ${profile.gender}');
              print('   BodyType: ${profile.bodyType}');

              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroHeader(profile, textTheme),
                      const SizedBox(height: 18),
                      _metrics(profile),
                      const SizedBox(height: 18),
                      _sectionCard(
                        title: 'Wellness Details',
                        children: [
                          _infoTile('Fitness Goal', profile.goal),
                          _infoTile('Body Type', profile.bodyType),
                          _infoTile('Gender', profile.gender),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _sectionCard(
                        title: 'Vitals',
                        children: [
                          _infoTile('Age', profile.age != null ? '${profile.age} yrs' : null),
                          _infoTile('Height', profile.height != null ? '${profile.height} cm' : null),
                          _infoTile('Weight', profile.weight != null ? '${profile.weight} kg' : null),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _logoutButton(context, ref),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _backgroundDecor() {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F1115), Color(0xFF0A0B0E)],
              ),
            ),
          ),
          Positioned(
            top: -120,
            left: -60,
            child: _blurCircle(220, const Color(0xFF3D5AFE).withOpacity(0.24)),
          ),
          Positioned(
            bottom: -140,
            right: -80,
            child: _blurCircle(260, const Color(0xFF64FFDA).withOpacity(0.20)),
          ),
        ],
      ),
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _softIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _heroHeader(UserProfile profile, TextTheme textTheme) {
    final displayName = profile.username.isNotEmpty ? profile.username : 'User';
    final displayEmail = profile.email.isNotEmpty ? profile.email : 'Email not available';

    return _glass(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFF64FFDA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  displayEmail,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _pill(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metrics(UserProfile profile) {
    final metrics = [
      _metricData('Age', profile.age != null ? '${profile.age} yrs' : 'Not set', Icons.cake_outlined),
      _metricData('Height', profile.height != null ? '${profile.height} cm' : 'Not set', Icons.height),
      _metricData('Weight', profile.weight != null ? '${profile.weight} kg' : 'Not set', Icons.monitor_weight_outlined),
      _metricData('Goal', _fallback(profile.goal), Icons.flag_outlined),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;
        final crossAxisCount = isCompact ? 1 : 2;
        final aspectRatio = isCompact ? 2.6 : 1.4;

        return _glass(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: metrics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: aspectRatio,
            ),
            itemBuilder: (context, index) {
              final item = metrics[index];
              return _metricTile(item);
            },
          ),
        );
      },
    );
  }

  Map<String, dynamic> _metricData(String label, String value, IconData icon) {
    return {'label': label, 'value': value, 'icon': icon};
  }

  Widget _metricTile(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x0DFFFFFF), Color(0x1AFFFFFF)],
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
                child: Icon(
                  data['icon'] as IconData,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
            ],
          ),
          Text(
            data['label'] as String,
            style: TextStyle(
              color: Colors.white70,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            data['value'] as String,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return _glass(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    final displayValue = _fallback(value);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
          ),
          const Spacer(),
          Text(
            displayValue,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton(BuildContext context, WidgetRef ref) {
    return _glass(
      padding: const EdgeInsets.all(4),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout, color: Colors.black),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            await ref.read(authProvider.notifier).logout();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            }
          },
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context, Object e, StackTrace stack, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _glass(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.amber, size: 48),
              const SizedBox(height: 12),
              Text(
                'Error loading profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                e.toString(),
                style: TextStyle(color: Colors.white70, fontFamily: GoogleFonts.plusJakartaSans().fontFamily),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text('Retry', style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => ref.invalidate(profileProvider),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.bug_report, color: Colors.white54),
                    onPressed: () {
                      print('📋 Full stack trace:');
                      print(stack.toString());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glass({required Widget child, EdgeInsets padding = EdgeInsets.zero}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0x1AFFFFFF), Color(0x0DFFFFFF)],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
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
