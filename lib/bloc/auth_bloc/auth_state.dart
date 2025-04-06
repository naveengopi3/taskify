part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class Authfailure extends AuthState {
  final String errorMessage;

  Authfailure({required this.errorMessage});
}
