import 'package:chat/models/BLoCs/Verification/verification_event.dart';
import 'package:chat/models/BLoCs/Verification/verification_state.dart';
import 'package:chat/services/auth_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class VerificationCodeBloc extends Bloc<VerificationCodeEvent, VerificationCodeState> {
  final AuthServices authRepository;

  VerificationCodeBloc({required this.authRepository}) : super(VerificationCodeInitial()) {
    on<VerifyCodeSubmitted>((event, emit) async {
      emit(VerificationCodeLoading());
      try {
        final isValid = await authRepository.validateCode(
          event.email,
          event.code,
          isForResetPassword: event.isForResetPassword,
        );
        if (isValid) {
          if (event.isForResetPassword) {
            final resetSuccess = await authRepository.resetPassword(
              event.email,
              event.newPassword,
            );
            if (resetSuccess) {
              emit(VerificationCodeSuccess());
            } else {
              emit(VerificationCodeFailure('Failed to Reset Password'));
            }
          } else {
            emit(VerificationCodeSuccess());
          }
        } else {
          emit(VerificationCodeFailure('Invalid verification code'));
        }
      } catch (e) {
        emit(VerificationCodeFailure(e.toString()));
      }
    });
  }
}
