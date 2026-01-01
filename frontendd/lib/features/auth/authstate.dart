class AuthState {
  final bool isLoading;
  final bool isuserloading;
  final bool isAuthenticated;
  final bool ?onboardingCompleted;
  final String?error;
  AuthState({
    this.isLoading=false,
    this.isuserloading=false,
    this.isAuthenticated=false,
    this.onboardingCompleted,

    this.error,
     });
   AuthState copyWith ({
    bool ? isLoading,
    bool ? isuserloading,
    bool ? isAuthenticated,
    bool ? onboardingCompleted,
    String? error,
   }){
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isuserloading: isuserloading ?? this.isuserloading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      error: error ?? this.error,
    );
   }
}