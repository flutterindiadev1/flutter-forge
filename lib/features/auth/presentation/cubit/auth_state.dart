import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final String email;
  final String displayName;
  const AuthAuthenticated({required this.email, required this.displayName});
  @override
  List<Object?> get props => [email, displayName];
}

class AuthEmailVerificationNeeded extends AuthState {
  final String email;
  final String password;
  const AuthEmailVerificationNeeded({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
