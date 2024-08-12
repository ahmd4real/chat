import 'package:chat/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthServices authServices;

  SignUpBloc({required this.authServices}) : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading());
      try {
        final worked = await authServices.signUp(
          event.email,
          event.password,
          event.firstName,
          event.lastName,
          event.confirmPassword,
        );
        if (worked) {
          await authServices.sendVerifyCode(event.email, false);
          emit(SignUpSuccess());
        } else {
          emit(SignUpFailure('Sign Up Failed'));
        }
      } catch (e) {
        emit(SignUpFailure(e.toString()));
      }
    });
  }
}
