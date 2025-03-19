part of 'login_bloc_bloc.dart';

@immutable
sealed class LoginBlocState {}

final class LoginBlocInitial extends LoginBlocState {}

final class LoginBlocLoading extends LoginBlocState {}

final class LoginBlocSuccess extends LoginBlocState {
  final String token;

  LoginBlocSuccess({required this.token});
}

final class LoginBlocFailure extends LoginBlocState {
  final String message;

  LoginBlocFailure({required this.message});
}