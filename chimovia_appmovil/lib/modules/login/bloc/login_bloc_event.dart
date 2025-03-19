part of 'login_bloc_bloc.dart';

@immutable
sealed class LoginBlocEvent {}

class ClickEnBotonDeIniciarSesion extends LoginBlocEvent {
  final String email;
  final String password;

  ClickEnBotonDeIniciarSesion({required this.email, required this.password});
}