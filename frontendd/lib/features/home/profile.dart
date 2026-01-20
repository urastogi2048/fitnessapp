

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
      backgroundColor: const Color.fromARGB(255, 31, 7, 7),
      body: profileAsync.when(
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _heroHeader(profile, textTheme),
                      const SizedBox(height: 20),
                      _metrics(profile),
                      const SizedBox(height: 16),
                      _sectionCard(
                        title: 'Wellness Details',
                        color: const Color.fromARGB(255, 2, 71, 128),
                        children: [
                          _infoTile('Fitness Goal', profile.goal),
                          _infoTile('Body Type', profile.bodyType),
                          _infoTile('Gender', profile.gender),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _sectionCard(
                        title: 'Vitals',
                        color: const Color.fromARGB(255, 136, 7, 7),
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
    );
  }

  Widget _heroHeader(UserProfile profile, TextTheme textTheme) {
    final displayName = profile.username.isNotEmpty ? profile.username : 'User';
    final displayEmail = profile.email.isNotEmpty ? profile.email : 'Email not available';

    return Card(
      color: const Color.fromARGB(255, 49, 1, 96),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 255, 87, 51), Color.fromARGB(255, 221, 44, 0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 40),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    displayEmail,
                    style: GoogleFonts.oswald(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
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
          label: item['label'] as String,
          value: item['value'] as String,
          icon: item['icon'] as IconData,
          color: item['color'] as Color,
        );
      },
    );
  }

  Widget _metricCard({
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

  Widget _sectionCard({required String title, required Color color, required List<Widget> children}) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    final displayValue = _fallback(value);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            displayValue,
            style: GoogleFonts.oswald(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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