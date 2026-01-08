// Profile Screen for Fitness App
// Shows fetched questionnaire/profile details + Logout

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 31, 7, 7),
      ),
      backgroundColor: const Color.fromARGB(255, 31, 7, 7),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (e, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Error loading profile',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    ref.invalidate(profileProvider);
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    print('📋 Full stack trace:');
                    print(stack.toString());
                  },
                  child: const Text('Show Debug Info', style: TextStyle(color: Colors.white54)),
                ),
              ],
            ),
          ),
        ),
        data: (profile) {
          // Debug: Log what we got
          print('🎨 Rendering profile screen with data:');
          print('   Username: "${profile.username}" (empty: ${profile.username.isEmpty})');
          print('   Email: "${profile.email}" (empty: ${profile.email.isEmpty})');
          print('   Age: ${profile.age}');
          print('   Height: ${profile.height}');
          print('   Weight: ${profile.weight}');
          print('   Goal: ${profile.goal}');
          print('   Gender: ${profile.gender}');
          print('   BodyType: ${profile.bodyType}');
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(profile),
                const SizedBox(height: 24),
                _sectionTitle('Questionnaire Details'),
                _infoTile('Age', profile.age != null ? '${profile.age} years' : null),
                _infoTile('Height', profile.height != null ? '${profile.height} cm' : null),
                _infoTile('Weight', profile.weight != null ? '${profile.weight} kg' : null),
                _infoTile('Fitness Goal', profile.goal),
                _infoTile('Gender', profile.gender),
                _infoTile('Body Type', profile.bodyType),
                const SizedBox(height: 40),
                _logoutButton(context, ref),
              ],
            ),
          );
        }),
      );
    
  }

  /// ---------------- COMPONENTS ----------------

  Widget _header(UserProfile profile) {
    final displayName = profile.username.isNotEmpty ? profile.username : 'User';
    final displayEmail = profile.email.isNotEmpty ? profile.email : 'Email not available';

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(displayName,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 4),
            Text(displayEmail, style: const TextStyle(color: Colors.grey)),
          ],
        )
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    final displayValue =
        (value != null && value.isNotEmpty) ? value : 'Not set';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: const Color.fromARGB(255, 50, 20, 20),
      child: ListTile(
        title: Text(label, style: const TextStyle(color: Colors.white70)),
        trailing: Text(displayValue,
            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
      ),
    );
  }

  Widget _logoutButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.redAccent,
        ),
        onPressed: () async {
          await ref.read(authProvider.notifier).logout();
          if (context.mounted) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/login', (_) => false);
          }
        },
      ),
    );
  }
}
