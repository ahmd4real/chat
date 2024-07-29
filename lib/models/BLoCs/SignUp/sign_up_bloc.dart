import 'package:chat/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';


class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthServices authRepository;

  SignUpBloc({required this.authRepository}) : super(SignUpInitial()) {
    on<SignUpSubmitted>((event, emit) async {
      emit(SignUpLoading());
      try {
        final worked = await authRepository.signUp(
          event.email,
          event.password,
          event.firstName,
          event.lastName,
          event.confirmPassword,
        );
        if (worked) {
          await authRepository.sendVerifyCode(event.email, false);
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
