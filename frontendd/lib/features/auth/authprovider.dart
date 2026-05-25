import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:state_notifier/state_notifier.dart';
import 'dart:io';
import '../../services/authservice.dart';
import '../../services/apiservices.dart';
import '../../core/tokenstorage.dart';
import '../../core/logger.dart';
import '../../core/network_exception.dart';
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
    } on NetworkException catch (e) {
      // Network error during init - keep session if token exists
      Logger.warn('Network error during auth check - keeping session alive');
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        error: 'No internet connection. Using cached session.',
      );
    } catch (e) {
      // Other errors - clear session
      Logger.error('Error checking auth status', e, null);
      await TokenStorage.clearAll();
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  /// 2. SIGNUP
  Future<void> signup(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      Logger.debug('Signup request for: ${email.length > 4 ? email.substring(0,4) + '...' : email}');
      await authService.signup(username, email, password);
      Logger.info('Signup successful for: ${email.length > 4 ? email.substring(0,4) + '...' : email}');
      state = state.copyWith(isLoading: false, error: null);
    } catch (e) {
      Logger.error('Signup failed', e, null);
      // Show actual error message from backend, fallback to generic if needed
      String errorMessage = 'Unable to create account';
      if (e.toString().contains('already exists')) {
        errorMessage = 'Email already registered';
      } else if (e.toString().contains('Invalid')) {
        errorMessage = e.toString();
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
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
      Logger.debug('Login request for: ${email.length > 4 ? email.substring(0,4) + '...' : email}');
      final data = await authService.login(email, password);
      final token = data['token'];

      if (token == null || token.toString().trim().isEmpty) {
        state = state.copyWith(isLoading: false, error: "No token received");
        return;
      }

      await TokenStorage.saveToken(token.toString());
      Logger.info('Login successful, fetching user');
      await fetchUser();
    } on NetworkException catch (e) {
      // Network error during login - show error but don't stay logged in
      Logger.error('Login failed - network error', e, null);
      await TokenStorage.clearAll();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: 'No internet connection. Please check your connection and try again.',
      );
    } on SocketException {
      await TokenStorage.clearAll();
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: 'No internet connection. Please check your connection and try again.',
      );
    } catch (e) {
      await TokenStorage.clearAll();
      Logger.error('Login failed', e, null);

      final err = e.toString().toLowerCase();
      if (err.contains('401') || err.contains('invalid') || err.contains('credentials') || err.contains('unauthorized')) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: 'Incorrect email or password',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: 'Login failed. Please try again.',
        );
      }
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
      } on NetworkException catch (e) {
        // NETWORK ERROR - DO NOT clear token or logout
        // Keep user logged in with cached session
        Logger.warn('Network error on attempt $attempt: keeping session alive');
        
        if (attempt < 2) {
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
        
        // After retries, assume offline but keep authenticated
        Logger.warn('Network unavailable after retries - keeping session alive for offline mode');
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true, // CRITICAL: Keep authenticated
          onboardingCompleted: true, // Assume onboarding done if we got this far
          username: state.username, // Keep cached username
          error: 'No internet connection. Some features may be limited.',
        );
        return;
      } on SocketException catch (e) {
        // SOCKET ERROR - Same as NetworkException
        Logger.warn('Socket error on attempt $attempt: keeping session alive');
        
        if (attempt < 2) {
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
        
        // After retries, assume offline but keep authenticated
        Logger.warn('Socket error after retries - keeping session alive for offline mode');
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true, // CRITICAL: Keep authenticated
          onboardingCompleted: true,
          username: state.username,
          error: 'No internet connection. Some features may be limited.',
        );
        return;
      } catch (e) {
        final errorStr = e.toString();

        if (errorStr.contains('401') ||
            errorStr.contains('403') ||
            errorStr.contains('Unauthorized')) {
          // ACTUAL AUTH ERROR - Only then clear token
          Logger.error('Authentication error (401/403) - logging out user', e, null);
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

        // Other errors - retry
        if (attempt < 2) {
          await Future.delayed(Duration(milliseconds: 500 * attempt));
          continue;
        }
      }
    }

    // Final fallback - if we still have token, keep user logged in
    final existingToken = await TokenStorage.getToken();
    if (existingToken != null && existingToken.isNotEmpty) {
      Logger.warn('Failed to fetch user but token exists - keeping session alive');
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        onboardingCompleted: true,
        error: 'Unable to load user data. Please check your connection.',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        error: 'Failed to load user data. Please try logging in again.',
      );
    }
  }
}

/// GLOBAL PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService, ref);
});
