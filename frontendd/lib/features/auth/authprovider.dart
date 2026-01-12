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
    print('🔐 LOGIN: Starting login for $email');
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('📡 LOGIN: Calling authService.login...');
      final data = await authService.login(email, password);
      print('✅ LOGIN: Received response: ${data.keys}');
      
      if (data['token'] != null) {
        print('🔑 LOGIN: Token received, saving...');
        await TokenStorage.saveToken(data['token']);
        print('👤 LOGIN: Fetching user data...');
        await fetchUser();
        print('✅ LOGIN: Login complete! Auth state: ${state.isAuthenticated}');
      } else {
        print('❌ LOGIN: No token in response');
        state = state.copyWith(isLoading: false, error: "Token not received");
      }
    } catch (e) {
      print('❌ LOGIN: Error during login: $e');
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
  print('👤 FETCH_USER: Starting...');
  try {
    final data = await authService.getMe();
    print('📦 FETCH_USER: Received data keys: ${data.keys}');

    final Map<String, dynamic> userData = data['user'];
    print('👤 FETCH_USER: User data keys: ${userData.keys}');

    final String? fetchedUsername = userData['username'];
    final bool serverOnboarding = userData['onboardingCompleted'] == true;
    final bool localOnboarding = await OnboardingStorage.isCompleted();

    print('✅ FETCH_USER: Success - username: $fetchedUsername, onboarding: $serverOnboarding');
    
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      onboardingCompleted: serverOnboarding || localOnboarding,
      username: fetchedUsername,
      error: null,
    );
  } catch (e) {
    print('❌ FETCH_USER: Error - $e');
    print('🗑️ FETCH_USER: Deleting token due to error');
    await TokenStorage.deleteToken();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      username: null,
      error: 'Failed to fetch user data: $e',
    );
  }
}

}

/// GLOBAL PROVIDER (Moved to bottom to ensure AuthNotifier is fully recognized)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});