import 'package:equatable/equatable.dart';

abstract class VerificationCodeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VerifyCodeSubmitted extends VerificationCodeEvent {
  final String email;
  final String code;
  final bool isForResetPassword;
  final String newPassword;

  VerifyCodeSubmitted({
    required this.email,
    required this.code,
    this.isForResetPassword = false,
    this.newPassword = "",
  });

  @override
  List<Object> get props => [email, code, isForResetPassword, newPassword];
}
