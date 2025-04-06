import 'package:bloc/bloc.dart';
import 'package:taskify/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authService.signUp(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess());
      } catch (e) {
        emit(Authfailure(errorMessage: e.toString()));
      }
    });

        on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.login(event.email, event.password);
        if (user != null && user.emailVerified) {
          await _authService.updateEmailVerifiedStatus(user);
          emit(AuthSuccess());
        } else {
          emit(Authfailure(errorMessage: "Please verify your email before logging in."));
        }
      } catch (e) {
        emit(Authfailure(errorMessage: e.toString()));
      }
    });
  }
}