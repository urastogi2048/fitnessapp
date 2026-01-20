class AuthState {
  final bool isLoading;        
  final bool isAuthenticated;
  final bool onboardingCompleted;
  final String? username;

  final String? error;
  //final UserState? user;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.onboardingCompleted = false,
    this.username,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? onboardingCompleted,
    String? username,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      onboardingCompleted:
      onboardingCompleted ?? this.onboardingCompleted,
      username: username ?? this.username,
      error: error,
    );
  }
}
