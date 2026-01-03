class AuthState {
  final bool isLoading;        // true until auth fully resolved
  final bool isAuthenticated;
  final bool onboardingCompleted;
  final String? error;

  const AuthState({
    this.isLoading = true,
    this.isAuthenticated = false,
    this.onboardingCompleted = false,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? onboardingCompleted,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      onboardingCompleted:
          onboardingCompleted ?? this.onboardingCompleted,
      error: error,
    );
  }
}
