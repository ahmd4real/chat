import 'package:chat/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthServices authServices;

  AuthBloc({required this.authServices}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authServices.login(event.email, event.password);
        emit(AuthSuccess(user['email'], user['firstName'], user['lastName']));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authServices.signUp(
          event.email,
          event.password,
          event.firstName,
          event.lastName,
          event.confirmPassword,
        );
        if (success) {
          emit(AuthSuccess(event.email, event.firstName, event.lastName));
        } else {
          emit(AuthFailure('Sign Up Failed'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
