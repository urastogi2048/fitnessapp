import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:state_notifier/state_notifier.dart';
import '../../services/authservice.dart';
import '../../services/apiservices.dart';
import '../../core/tokenstorage.dart';
import '../../core/onboardingstorage.dart';
import 'authstate.dart';

/// Shared service providers
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authServiceProvider = Provider<AuthService>((ref) {
  final api = ref.read(apiServiceProvider);
  return AuthService(api);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(const AuthState());

  /// 1. APP INITIALIZATION
  Future<void> checkAuthStatus() async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
      return;
    }
    await fetchUser();
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
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await authService.login(email, password);
      if (data['token'] != null) {
        await TokenStorage.saveToken(data['token']);
        await fetchUser();
      } else {
        state = state.copyWith(isLoading: false, error: "Token not received");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), isAuthenticated: false);
    }
  }

  /// 4. LOGOUT
  Future<void> logout() async {
    await TokenStorage.deleteToken();
    await OnboardingStorage.clearCompleted();
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
  try {
    final data = await authService.getMe();

    final Map<String, dynamic> userData = data['user'];

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
  } catch (e) {
    await TokenStorage.deleteToken();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      username: null,
    );
  }
}

}

/// GLOBAL PROVIDER (Moved to bottom to ensure AuthNotifier is fully recognized)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});