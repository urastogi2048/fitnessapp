import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:state_notifier/state_notifier.dart';
import 'dart:io';
import '../../services/authservice.dart';
import '../../services/apiservices.dart';
import '../../core/tokenstorage.dart';
import '../../core/onboardingstorage.dart';
import 'authstate.dart';
import '../home/profile.dart' show profileProvider;
import '../progress/statprovider.dart';

/// Shared service providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authServiceProvider = Provider<AuthService>((ref) {
  final api = ref.read(apiServiceProvider);
  return AuthService(api);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;
  final Ref ref;

  AuthNotifier(this.authService, this.ref) : super(const AuthState());

  /// 1. APP INITIALIZATION
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await TokenStorage.getToken();
      if (token == null || token.isEmpty) {
        state = state.copyWith(isLoading: false, isAuthenticated: false);
        return;
      }
      await fetchUser();
    } catch (e) {
      await TokenStorage.clearAll();
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  /// 2. SIGNUP
  Future<void> signup(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await authService.signup(username, email, password);
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// 3. LOGIN
  Future<void> login(String email, String password) async {
    // COMPLETE WIPE before new login
    await TokenStorage.clearAll();
    await OnboardingStorage.clearCompleted();

    state = state.copyWith(
      isLoading: true,
      isAuthenticated: false,
      username: null,
      onboardingCompleted: false,
      error: null,
    );

    try {
      if (email.trim().isEmpty || password.isEmpty) {
        throw Exception('Email and password cannot be empty');
      }

      final data = await authService.login(email, password);
      final token = data['token'];

      if (token == null || token.toString().trim().isEmpty) {
        state = state.copyWith(isLoading: false, error: "No token received");
        return;
      }

      await TokenStorage.saveToken(token.toString());
      await fetchUser();
    } on SocketException {
      await TokenStorage.clearAll();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: 'Network error',
      );
    } catch (e) {
      await TokenStorage.clearAll();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: e.toString(),
      );
    }
  }

  /// 4. LOGOUT
  Future<void> logout() async {
    // COMPLETE WIPE - clear everything
    await TokenStorage.clearAll();
    await OnboardingStorage.clearCompleted();

    // Invalidate profile cache
    ref.invalidate(profileProvider);
    ref.invalidate(monthlyDaywiseProvider);
    ref.invalidate(weeklyDaywiseProvider);
    ref.invalidate(weeklyBodyPartwiseProvider);
    ref.invalidate(monthlyBodyPartwiseProvider);

    // Reset state completely
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      onboardingCompleted: false,
      username: null,
      error: null,
    );
  }

  /// 5. FETCH USER & ONBOARDING STATUS
  Future<void> fetchUser() async {
    for (int attempt = 1; attempt <= 2; attempt++) {
      try {
        final data = await authService.getMe();

        if (!data.containsKey('user')) {
          throw Exception('Invalid response: missing user data');
        }

        final Map<String, dynamic> userData = data['user'] ?? {};
        if (userData.isEmpty) {
          throw Exception('User data is empty');
        }

        final String? fetchedUsername = userData['username'];
        final bool serverOnboarding = userData['onboardingCompleted'] == true;
        final bool localOnboarding = await OnboardingStorage.isCompleted();

        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          onboardingCompleted: serverOnboarding || localOnboarding,
          username: fetchedUsername,
          error: null,
        );
        return;
      } on SocketException {
        if (attempt < 2) {
          await Future.delayed(Duration(milliseconds: 500));
          continue;
        }
      } catch (e) {
        final errorStr = e.toString();

        if (errorStr.contains('401') ||
            errorStr.contains('403') ||
            errorStr.contains('Unauthorized')) {
          await TokenStorage.clearAll();
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            username: null,
            onboardingCompleted: false,
            error: 'Session expired. Please login again.',
          );
          return;
        }

        if (attempt < 2) {
          await Future.delayed(Duration(milliseconds: 500));
          continue;
        }
      }
    }

    await TokenStorage.clearAll();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      username: null,
      onboardingCompleted: false,
      error: 'Failed to load user data. Please try logging in again.',
    );
  }
}

/// GLOBAL PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService, ref);
});
