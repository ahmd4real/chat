import 'package:equatable/equatable.dart';

abstract class VerificationCodeState extends Equatable {
  @override
  List<Object> get props => [];
}

class VerificationCodeInitial extends VerificationCodeState {}

class VerificationCodeLoading extends VerificationCodeState {}

class VerificationCodeSuccess extends VerificationCodeState {}

class VerificationCodeFailure extends VerificationCodeState {
  final String error;

  VerificationCodeFailure(this.error);

  @override
  List<Object> get props => [error];
}
