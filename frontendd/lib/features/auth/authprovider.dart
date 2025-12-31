import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:frontendd/core/tokenstorage.dart';
import '../../services/authservice.dart';
import '../../services/apiservices.dart';
import 'authstate.dart';
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref){
  return AuthNotifier(AuthService(ApiService()));
});
class AuthNotifier extends StateNotifier<AuthState>{
  final AuthService authservice;
  AuthNotifier(this.authservice) : super(AuthState());
  Future<void> checkAuthStatus() async {
  final token = await TokenStorage.getToken();

  if (token == null) {
    state = state.copyWith(isAuthenticated: false, isuserloading: false);
    return;
  }
  state = state.copyWith(isAuthenticated: true, isuserloading: true);
  await fetchCurrentUser();

}

  Future<void> login(String email, String password) async {
    state =  state.copyWith(isLoading : true, error:null);
    try{
      final data = await authservice.login(email,password);
      final token = data["token"] ;
      await TokenStorage.saveToken(token);
      state = state.copyWith(isLoading: false, isAuthenticated: true);
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
  Future<void> fetchCurrentUser() async {
    state = state.copyWith(isuserloading:true);
     try {
    final data = await authservice.getMe(); // calls /users/me
    state = state.copyWith(
      isuserloading: false,
      onboardingCompleted: data["onboardingCompleted"],
    );
  } catch (e) {
    // token invalid / user deleted
    await TokenStorage.deleteToken();
    state = state.copyWith(
  isAuthenticated: false,
  isuserloading: false,
  error: "Session expired. Please login again.",
);
  }

  }
  

  
}