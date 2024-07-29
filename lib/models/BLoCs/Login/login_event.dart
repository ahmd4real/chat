import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String confirmPassword;

  SignUpEvent(
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.confirmPassword,
  );

  @override
  List<Object> get props =>
      [email, password, firstName, lastName, confirmPassword];
}
