import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontendd/core/tokenstorage.dart';
import '../../services/authservice.dart';
import '../../services/apiservices.dart';
import 'authstate.dart';
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref){
  ref.keepAlive();
  return AuthNotifier(AuthService(ApiService()));
});
class AuthNotifier extends StateNotifier<AuthState>{
  final AuthService authservice;
  AuthNotifier(this.authservice) : super(AuthState());
  Future<void> checkAuthStatus() async {
  final token = await TokenStorage.getToken();

  if (token == null) {
    state = AuthState(); // clean reset
    return;
  }

  state = state.copyWith(isuserloading: true);
  await fetchCurrentUser();
}
  Future<void> login(String email, String password) async {
    state =  state.copyWith(isLoading : true, error:null);
    try{
      final data = await authservice.login(email,password);
      final token = data["token"] ;
      await TokenStorage.saveToken(token);
      state = state.copyWith(isLoading: false, isuserloading: true, isAuthenticated: true);
      await fetchCurrentUser();
    

    }
    catch(e){
      state = state.copyWith(isLoading: false, error: e.toString());

    }
  }
  Future<void> signup (
    String username,String email, String 
    
    password,

  )
  async {
    state =state.copyWith(isLoading: true, error: null);
    try {
      await authservice.signup(username, email, password);
      state = state.copyWith(isLoading: false);
    }
    catch(e){
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  Future<void> markOnboardingComplete() async {
  state = state.copyWith(isuserloading: true);

  try {
    // re-fetch user from backend
    final data = await authservice.getMe();

    state = state.copyWith(
      isAuthenticated: true,
      onboardingCompleted: data["onboardingCompleted"],
      isuserloading: false,
    );
  } catch (e) {
    state = state.copyWith(
      isAuthenticated: false,
      isuserloading: false,
      error: "Failed to refresh user state",
    );
  }
}


  Future<void> fetchCurrentUser() async {
  try {
    final data = await authservice.getMe();

    state = state.copyWith(
      isAuthenticated: true,
      onboardingCompleted: data["onboardingCompleted"], // TRUE OR FALSE
      isuserloading: false,
    );
  } catch (e) {
    await TokenStorage.deleteToken();
    state = AuthState();
  }
}
  

  
}