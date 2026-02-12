part of 'login_screen_bloc.dart';

@immutable
sealed class LoginScreenEvent {}

final class LoginSubmitEvent extends LoginScreenEvent {
  final String username;
  final String password;

  LoginSubmitEvent(this.username, this.password);
}